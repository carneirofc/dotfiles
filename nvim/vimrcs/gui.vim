" GUI related

" Set font according to system https://download.jetbrains.com/fonts/JetBrainsMono-1.0.3.zip?_ga=2.21246782.427104117.1586269112-2045209984.1586269112
set gfn="JetBrainsMono Nerd Font"

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

try
    " Colorscheme
    set background=dark
    colorscheme peaksea
catch
endtry
