interact.vim
============

Introduction
------------

`interact.vim`'s primary intended use is to allow one to load code from
a working buffer into an interpreter using simple key mappings, thereby
acting as a primitive yet unobtrusive IDE replacement.

The interpreter is to be run inside a GNU Screen session; `interact.vim`
uses Screen's `stuff` command to blindly push text through to whatever
is in the selected Screen window, which doesn't have to be a language
interpreter. Vim itself doesn't need to be run from Screen; this plugin
works just as well with GVim.

Read the initial comment on the source file itself for more on how to
use it.


Installation
------------

Either:

- put `interact.vim` in `~/.vim/plugin/`;

- or, as I do, keep it somewhere like `~/.vim/autoload` and have the
  script load for certain filetypes only, e.g. for Lisp files:

  `echo 'source ~/.vim/autoload/interact.vim' >> ~/.vim/ftplugin/lisp.vim`
