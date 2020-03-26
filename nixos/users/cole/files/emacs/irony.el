;;; irony.el
;;;
;;; Irony config for emacs

(use-package irony
  :mode (("\\.cpp\\'" . c++-mode)
         ("\\.cc\\'"  . c++-mode)
         ("\\.hpp\\'" . c++-mode)
         ("\\.hh\\'"  . c++-mode)
         ("\\.c\\'"   . c-mode)
         ("\\.h\\'"   . c-mode))
  :config

  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async)
    (irony-cdb-autosetup-compile-options)
    (company-mode))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)

  (use-package flycheck-irony
    :ensure t
    :config
    (eval-after-load 'flycheck
      '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)))

  (use-package company-irony-c-headers
    :ensure t
    :config
    (eval-after-load 'company
      '(add-to-list
        'company-backends '(company-irony-c-headers company-irony))))

  (use-package clang-format
    :ensure t
    :config
    (global-set-key [C-M-tab] 'clang-format-region)))

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
