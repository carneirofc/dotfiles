#!/usr/env/bin python
import os.path as p
import os
import sys

SOURCE_EXTENSIONS = [".cpp", ".cxx", ".cc", ".c", ".m", ".mm"]

database = None

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
flags = [
    "-Wall",
    "-Wextra",  # reasonable and standard
    "-Wshadow",  # warn the user if a variable declaration shadows one from a parent context
    "-Wnon-virtual-dtor",  # warn the user if a class with virtual functions has a non-virtual destructor. This helps catch hard to track down memory errors
    "-Wold-style-cast",  # warn for c-style casts
    "-Wcast-align",  # warn for potential performance problem casts
    "-Wunused",  # warn on anything being unused
    "-Woverloaded-virtual",  # warn if you overload (not override) a virtual function
    "-Wpedantic",  # warn if non-standard C++ is used
    "-Wconversion",  # warn on type conversions that may lose data
    "-Wsign-conversion",  # warn on sign conversions
    "-Wnull-dereference",  # warn if a null dereference is detected
    "-Wdouble-promotion",  # warn if float is implicit promoted to double
    "-Wformat=2",  # warn on security issues around functions that format output (ie printf)
    "-Wimplicit-fallthrough",  # warn on statements that fallthrough without an explicit annotation
    "-Wmisleading-indentation",  # warn if indentation implies blocks where blocks do not exist
    "-Wduplicated-cond",  # warn if if / else chain has duplicated conditions
    "-Wduplicated-branches",  # warn if if / else branches have duplicated code
    "-Wlogical-op",  # warn about logical operations being used where bitwise were probably wanted
    "-Wuseless-cast",  # warn if you perform a cast to the same type
    "-Wno-long-long",
    "-Wno-variadic-macros",
    "-fexceptions",
    "-DNDEBUG",
    # THIS IS IMPORTANT! Without the '-x' flag, Clang won't know which language to
    # use when compiling headers. So it will guess. Badly. So C++ headers will be
    # compiled as C headers. You don't want that so ALWAYS specify the '-x' flag.
    # For a C project, you would set this to 'c' instead of 'c++'.
    "-x",
    "c++",
    # "-isystem",
    # "-I",
    "-std=c++2a",
]

if os.environ.get("EPICS_BASE", ""):
    flags.append("-isystem")
    flags.append(os.path.join(os.environ.get("EPICS_BASE", ""), "include/"))
    flags.append("-isystem")
    flags.append(os.path.join(os.environ.get("EPICS_BASE", ""), "src/"))


# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.
def FindFiles(filename, search_path):
    result = []

    # Wlaking top-down from the root
    for root, _dir, files in os.walk(search_path):
        if filename in files:
            result.append(os.path.join(root, filename))
    return result[0] if result else ""


def CompilationDatabaseFolder():
    _db = FindFiles("compile_commands.json", ".")
    return os.path.dirname(_db) if _db else ""


compilation_database_folder = CompilationDatabaseFolder()


def IsHeaderFile(filename):
    extension = p.splitext(filename)[1]
    return extension in [".h", ".hxx", ".hpp", ".hh"]


def FindCorrespondingSourceFile(filename):
    if IsHeaderFile(filename):
        basename = p.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if p.exists(replacement_file):
                return replacement_file
    return filename


def Settings(**kwargs):
    # Do NOT import ycm_core at module scope.
    import ycm_core

    global database
    if database is None and p.exists(compilation_database_folder):
        database = ycm_core.CompilationDatabase(compilation_database_folder)

    language = kwargs["language"]

    if language == "cfamily":
        # If the file is a header, try to find the corresponding source file and
        # retrieve its flags from the compilation database if using one. This is
        # necessary since compilation databases don't have entries for header files.
        # In addition, use this source file as the translation unit. This makes it
        # possible to jump from a declaration in the header file to its definition
        # in the corresponding source file.
        filename = FindCorrespondingSourceFile(kwargs["filename"])

        if not database:
            return {
                "flags": flags,
                "include_paths_relative_to_dir": os.getcwd(),
                "override_filename": filename,
            }

        compilation_info = database.GetCompilationInfoForFile(filename)
        if not compilation_info.compiler_flags_:
            return {}

        # Bear in mind that compilation_info.compiler_flags_ does NOT return a
        # python list, but a "list-like" StringVec object.
        final_flags = list(compilation_info.compiler_flags_)

        return {
            "flags": final_flags,
            "include_paths_relative_to_dir": compilation_info.compiler_working_dir_,
            "override_filename": filename,
        }

    if language == "python":
        return {"interpreter_path": sys.executable}

    return {}
