## EEC

Experimental Emacs Config

> [!WARNING]
> Not intended for general use. This is strictly for personal use.

A bare bones personal Emacs configuration designed for constrained environments to work with C++ files (primarily virtual machines).

The `early-init.el` uses some tips from [D4lj337/Emacs-performance](https://github.com/D4lj337/Emacs-performance) 

## **`bare-cpp-mode`** && **`bare-go-mode`**

* Derived from `fundamental-mode`
* Completely stripped down
* Exists solely as a handle for Eglot

## Components

* Eglot (with `clangd`)
* Flymake (minimal configuration)
* clang-format, goimports, gofmt

> **Note**
> Does NOT use `company-mode` and `cc-mode.`

## Usage

1. `imenu`: `C-c C-v`
2. Format document: `C-c C-f`
3. Jump to header: `C-c C-o`
4. Completion at point: `C-<tab>`
5. Trigger goimports: `C-c C-n`