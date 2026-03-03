;;; init.el --- Emacs Init File -*- lexical-binding: t; -*-

(setq
 tramp-backup-directory-alist nil
 session-initialize nil)

(setq-default bidi-display-reordering 'left-to-right)
(setq bidi-inhibit-bpa t)

(setq fast-but-imprecise-scrolling t
      jit-lock-defer-time 0)

(blink-cursor-mode 0)
(fido-vertical-mode 1)
(when (display-graphic-p)
  (context-menu-mode))


(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; EGLOT _BEGIN_

(define-derived-mode bare-cpp-mode fundamental-mode "Bare-C++"
  "A completely stripped-down mode for C/C++ files.
No font-locking, no indentation, no cc-mode. Used solely to anchor Eglot.")

(let ((clean-alist nil))
  (dolist (entry auto-mode-alist)
    (unless (memq (cdr entry) '(c-mode c++-mode c-or-c++-mode objc-mode java-mode))
      (push entry clean-alist)))
  (setq auto-mode-alist (nreverse clean-alist)))

(add-to-list 'auto-mode-alist '("\\.cpp\\'" . bare-cpp-mode))
(add-to-list 'auto-mode-alist '("\\.hpp\\'" . bare-cpp-mode))
(add-to-list 'auto-mode-alist '("\\.cxx\\'" . bare-cpp-mode))
(add-to-list 'auto-mode-alist '("\\.hxx\\'" . bare-cpp-mode))
(add-to-list 'auto-mode-alist '("\\.cc\\'" . bare-cpp-mode))
(add-to-list 'auto-mode-alist '("\\.hh\\'" . bare-cpp-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'"   . bare-cpp-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'"   . bare-cpp-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(bare-cpp-mode . ("clangd"
                                  "--background-index"
                                  "-j=4"
                                  "--clang-tidy"
                                  "--completion-style=detailed" 
                                  "--header-insertion=never"
                                  "--pch-storage=memory"))))

(setq read-process-output-max (* 3 1024 1024)
      eglot-events-buffer-size 0
      eglot-extend-to-xref t)

(setq eglot-ignored-server-capabilities '(:inlayHintProvider
					  :semanticTokensProvider
					  :documentHighlightProvider
					  :hoverProvider
					  :documentFormamttingProvider
					  :documentRangeFormattingProvider
					  :documentOnTypeFormattingProvider
					  :colorProvider
					  :foldingRangeProvider
				       	  :codeLensProvider
					  ))

(add-hook 'bare-cpp-mode-hook 'eglot-ensure)
(setq eglot-autostart-file-watchers nil)

(setq completion-auto-select t)
(setq completion-cycle-threshold 3)
(setq tab-always-indent 'complete)
(add-hook 'minibuffer-exit-hook 'minibuffer-hide-completions)


(with-eval-after-load 'flymake
  (setq flymake-no-changes-timeout 2.0
	flymake-start-on-flymake-mode nil))

;; EGLOT _END_

(global-unset-key (kbd "C-M-i")) ;; Due to VM use.
(define-key bare-cpp-mode-map (kbd "C-<tab>") 'completion-at-point)
