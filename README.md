## EEC

Experimental Emacs Config

> [!WARNING]
> Not intended for general use. This is strictly for personal use.

A bare bones personal Emacs configuration designed for constrained environments to work with C++ files (primarily virtual machines).

The `early-init.el` uses some tips from [D4lj337/Emacs-performance](https://github.com/D4lj337/Emacs-performance) 

## **`bare-cpp-mode`**

* Derived from `fundamental-mode`
* Completely stripped down
* Exists solely as a handle for Eglot

## Components

* Eglot (with `clangd`)
* Flymake (minimal configuration)

> **Note**
> Does NOT use `company-mode` and `cc-mode.`