" interact.vim - Send text to a GNU Screen window
"
" Author:       Miguel Fonseca <miguelcsf@gmail.com>
" Copyright:    Public domain
" Created:      2010-07-25
" Last Update:  2011-11-18
"
" Originally intended as a cheap replacement for EMACS+SLIME, interact.vim
" sends the contents of a buffer region or register to a given window on a GNU
" Screen session, and appends a newline to the piped text. This makes for a
" simple way to interact with a language interpreter, evaluating definitions
" and calls and so on.
"
" interact.vim automatically asks for a GNU Screen session PID (unless only
" one session is found) and a GNU Screen window number or name. These values
" can be reconfigured (check below for corresponding mapping).
"
"
" Default Mappings:
"
" Insert mode:
" C-c C-c   send current line and return
"
" Normal mode:
" C-c C-a   send whole buffer
" C-c C-c   send current paragraph
" C-c C-l   send current line
" C-c v     reconfigure session
"
" Visual mode
" C-c C-c   send selected region


function! Send_to_Screen(text)
  if !exists("g:screen_sessionname") || !exists("g:screen_windowname")
    call Screen_Vars()
  end
  echo system("screen -S " . g:screen_sessionname . " -p "
                \ . g:screen_windowname . " -X stuff '"
                \ . substitute(a:text, "'", "'\\\\''", 'g') . "'")
endfunction

function! s:Screen_Session_Count()
    return system("screen -ls | awk '/Attached/ {print $1}' | wc -l")
endfunction

function! s:Screen_Session_Only()
    return system("screen -ls | awk '/Attached/ {printf \"%s\", $1}'")
endfunction

function! Screen_Session_Names() "(A,L,P)
  return system("screen -ls | awk '/Attached/ {print $1}'")
endfunction

function! Screen_Vars()
  if !exists("g:screen_sessionname") || !exists("g:screen_windowname")
    let g:screen_sessionname = ""
    let g:screen_windowname = "0"
  end

  if s:Screen_Session_Count() == 1
      let g:screen_sessionname = s:Screen_Session_Only()
  else
      echo "Attached Screen Sessions:"
      echo Screen_Session_Names()
      let g:screen_sessionname = input("session name: ", "",
                  \ "custom,Screen_Session_Names")
  endif
  let g:screen_windowname = input("window name: ", g:screen_windowname)

endfunction


imap <C-c><C-c> <C-o>:.y r<cr><C-o>:call Send_to_Screen(@r)<cr><C-o>o
nmap <C-c><C-a> :%y r<cr>:call Send_to_Screen(@r)<cr>
nmap <C-c><C-c> vip<C-c><C-c>
nmap <C-c><C-l> :.y r<cr>:call Send_to_Screen(@r)<cr>
nmap <C-c>v :call Screen_Vars()<cr>
vmap <C-c><C-c> "ry :call Send_to_Screen(@r)<cr>
