;;;; init.el
;;;;
;;;; Author: Cole Scott

;; Push the current directory onto the load path
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Enable use-package
(eval-when-compile
  (require 'use-package))

(package-initialize)

;; Fira code
(require 'fira-code-mode)
(global-fira-code-mode)

(require 'setup-c)
(require 'setup-lsp)

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

(use-package smart-mode-line
  :init (add-hook 'after-init-hook 'sml/setup)
  :config
  (setq sml/theme nil))

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
   '((gnuplot . t)
     (dot . t)))

  ;; Org mode citations
  (require 'oc-basic)
  (require 'oc-csl)
  (require 'oc-biblatex)

  ;; Add templates
  (add-to-list 'org-modules 'org-tempo t)
  (add-to-list 'org-structure-template-alist
    '("dot" . "src dot"))
  (add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))

  (setq org-agenda-files '("~/org/journal.org"))
  (setq org-capture-templates
        '(("j" "Journal Entry"
           entry (file+olp+datetree "~/org/journal.org")
           "* %U %?"
           :empty-lines 1)
          ("e" "Add Event"
           entry (file+olp+datetree "~/org/journal.org")
           "* %T %?"
           :time-prompt t)
          ("t" "Add TODO"
           entry (file+olp+datetree "~/org/journal.org")
           "* TODO %T %?"
           :time-prompt t)
          ("T" "Add TODO with deadline"
           entry (file+olp+datetree "~/org/journal.org")
           "* TODO %T %?
DEADLINE: %^t"
           :time-prompt t)
          ("m" "Set current day mood"
           entry (file+olp+datetree "~/org/journal.org")
           "%(progn
(interactive)
(save-excursion (org-up-heading-safe)
  (org-set-property \"Mood\" (org-read-property-value \"Mood\")))
\"done\")
%?")))
  (define-key global-map (kbd "C-c x")
    (lambda () (interactive) (org-capture))))

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
    ;; Change workgroups session file
    (setq wg-session-file "~/.emacs.d/.emacs_workgroups")
    (setq wg-mode-line-display-on t)
   (workgroups-mode nil)))

(use-package slime
  :config
  (progn
    (load (expand-file-name "~/quicklisp/slime-helper.el"))

    (setq lisp-indent-function 'common-lisp-indent-function)
    (push 'slime-indentation slime-contribs)
    
    (setq inferior-lisp-program "sbcl")
    (defadvice slime-repl-insert-prompt (after font-lock-face activate)
      (let ((inhibit-read-only t))
        (add-text-properties
         slime-repl-prompt-start-mark (point)
         '(font-lock-face
           slime-repl-prompt-face
           rear-nonsticky
           (slime-repl-prompt read-only font-lock-face intangible)))))))

(defun remove-trailing-whitespace-on-save ()
  (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))
(add-hook 'lisp-mode-hook #'remove-trailing-whitespace-on-save)

