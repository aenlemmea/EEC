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

(add-to-list 'auto-mode-alist 
             '("\\.\\(c\\|cc\\|cpp\\|cxx\\|h\\|hh\\|hpp\\|hxx\\)\\'" . bare-cpp-mode))

(define-derived-mode bare-go-mode fundamental-mode "Bare-Go")
(add-to-list 'auto-mode-alist '("\\.go\\'" . bare-go-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(bare-cpp-mode . ("clangd"
                                  "--background-index"
                                  "-j=4"
                                  "--clang-tidy"
                                  "--completion-style=detailed" 
                                  "--header-insertion=never"
                                  "--pch-storage=memory")))
   (add-to-list 'eglot-server-programs
               '(bare-go-mode . ("gopls"))))

(add-hook 'bare-go-mode-hook 'eglot-ensure)

(setq read-process-output-max (* 3 1024 1024)
      eglot-events-buffer-size 0
      eglot-extend-to-xref t)

(setq eglot-ignored-server-capabilities '(:inlayHintProvider
					  :semanticTokensProvider
					  :documentHighlightProvider
					  :hoverProvider
					  :documentFormattingProvider
					  :documentRangeFormattingProvider
					  :documentOnTypeFormattingProvider
					  :colorProvider
					  :foldingRangeProvider
				       	  :codeLensProvider
					  ))

(add-hook 'bare-cpp-mode-hook 'eglot-ensure)
(setq eglot-autostart-file-watchers nil)

(setq completion-auto-select t
      completion-cycle-threshold 3
      tab-always-indent 'complete)
(add-hook 'minibuffer-exit-hook 'minibuffer-hide-completions)


(with-eval-after-load 'flymake
  (setq flymake-no-changes-timeout 2.0
	flymake-start-on-flymake-mode nil))

;; EGLOT _END_

(defun my-go-imports-fast ()
  "Run goimports directly on the buffer to format and organize imports."
  (interactive)
  ;; Pipes the whole buffer to the CLI tool and replaces it (the 't' argument)
  (shell-command-on-region (point-min) (point-max) "goimports" nil t))

(define-key bare-go-mode-map (kbd "C-c C-n") #'my-go-imports-fast)

(defun my-go-fmt-fast ()
  "Run gofmt directly on the current file."
  (interactive)
  (shell-command-on-region (point-min) (point-max) "gofmt" nil t))

(define-key bare-go-mode-map (kbd "C-c C-f") #'my-go-fmt-fast)

(defun my-cpp-switch-header-source ()
  "Switch between C/C++ header and source file using clangd LSP."
  (interactive)
  (if-let* ((server (eglot-current-server))
            (uri (eglot-path-to-uri (buffer-file-name)))
            ;; Call clangd's custom method directly 
            (target-uri (jsonrpc-request server
                                         :textDocument/switchSourceHeader
                                         (list :uri uri)))
            ;; target-uri is returned as a string; convert it back to a local file path
            (target-path (eglot-uri-to-path target-uri)))
      (find-file target-path)
    (message "Clangd could not find a corresponding header/source file.")))

(defun my-cpp-fmt-fast ()
  "Run clang-format directly on the current file, replacing the buffer."
  (interactive)
  ;; Pipes the buffer to clang-format and replaces it (the 't' argument)
  (shell-command-on-region (point-min) (point-max) "clang-format" nil t))

(define-key bare-cpp-mode-map (kbd "C-c C-o") #'my-cpp-switch-header-source)
(define-key bare-cpp-mode-map (kbd "C-c C-f") #'my-cpp-fmt-fast)
(define-key bare-cpp-mode-map (kbd "C-c C-v") #'imenu)


(global-unset-key (kbd "C-M-i")) ;; Due to VM use.
(define-key bare-cpp-mode-map (kbd "C-<tab>") 'completion-at-point)
(define-key bare-go-mode-map (kbd "C-<tab>") 'completion-at-point)
