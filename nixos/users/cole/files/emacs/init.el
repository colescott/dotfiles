;;;; init.el
;;;;
;;;; Author: Cole Scott

;; Push the current directory onto the load path
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Enable use-package
(eval-when-compile
  (require 'use-package))

(package-initialize)

(require 'fira-code-mode)
(require 'setup-c)

(use-package nix-mode
  :mode "\\.nix\\'"
  :custom
  (nix-indent-function #'nix-indent-line))

(use-package multi-term
  :config
  (progn
    (add-hook 'multi-term-hook
              (lambda ()
                (setq show-trailing-whitespace nil
                      truncate-lines t)))))

(use-package solarized-theme
  :config (load-theme 'solarized-dark t))

(use-package company
  :config
  (progn
    (global-company-mode)
    (setq company-idle-delay 0.1)
    (add-to-list 'company-backends 'company-irony)
    (define-key company-active-map (kbd "C-n") (lambda () (interactive) (company-complete-common-or-cycle 1)))
    (define-key company-active-map (kbd "C-p") (lambda () (interactive) (company-complete-common-or-cycle -1)))))

(with-eval-after-load 'flycheck
  (global-flycheck-mode))

;; Set backups folder
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

;; Trust themes by default
(setq custom-safe-themes t)
;; Remove scrollbars
(toggle-scroll-bar -1)
;; Remove toolbar
(tool-bar-mode -1)
;; Remove menu bar
(menu-bar-mode -1)
;; Enable line numbers
(global-display-line-numbers-mode)
;; Show column numbers
(column-number-mode 1)
;; Show matching parens
(setq show-paren-delay 0)
(show-paren-mode 1)
;; Enabled shift+arrow movement
(windmove-default-keybindings)
;; Disable tabs for indentation
(setq-default indent-tabs-mode nil)
;; Disable splash screen and startup message
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(defalias 'yes-or-no-p 'y-or-n-p)

;; Org mode
(use-package org
  :config
  (define-key global-map "\C-cl" 'org-store-link)
  (define-key global-map "\C-ca" 'org-agenda)
  (setq org-log-done 'time)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((gnuplot . t))))

;; Helm mode
(use-package helm
  :bind (("M-x"     . helm-M-x)
         ("C-x r b" . helm-filtered-bookmarks)
         ("C-x C-f" . helm-find-files)
         :map helm-map
         ("TAB" . helm-execute-persistent-action)
         ("<tab>" . helm-execute-persistent-action)
         ("C-z" . helm-select-action)))

(use-package paredit
  :commands paredit-mode
  :hook ((emacs-lisp-mode
         eval-expression-minibuffer-setup
         ielm-mode
         lisp-mode
         lisp-interaction-mode
         scheme-mode)
         . 'enable-paredit-mode)
  :config (autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t))

(use-package workgroups2
  :config
  (progn
    ;; Change prefix key
    (setq wg-prefix-key (kbd "C-a"))
    ;; Change workgroups session file
    (setq wg-session-file "~/.emacs.d/.emacs_workgroups")
    (setq wg-mode-line-display-on t)
   (workgroups-mode 1)))

(use-package slime
  :config
  (progn
    (load (expand-file-name "~/quicklisp/slime-helper.el"))
    (setq inferior-lisp-program "sbcl")))
