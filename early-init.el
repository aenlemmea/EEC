(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1 MB
(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)

(setq package-enable-at-startup nil)
(setq package-quickstart t)
(setq use-package-always-defer t)

(setq
 inhibit-splash-screen t
 inhibit-startup-screen t
 initial-scratch-message ""
 initial-buffer-choice nil
 inhibit-startup-message t
 inhibit-startup-buffer-menu t)

(setq
 inhibit-startup-echo-area-message user-login-name
 mode-line-format nil
 site-run-file nil
 make-backup-files nil
 backup-inhibited t
 auto-save-default nil
 auto-save-list-file-prefix nil
 auto-save-list-file-name nil
 create-lockfiles nil
 version-control nil
 auto-save-interval 0
 auto-save-timeout 0
 debug-on-error nil)

(setq initial-major-mode 'fundamental-mode)


(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq frame-inhibit-implied-resize t)
