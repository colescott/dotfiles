(use-package lsp-mode
  :config
  (add-hook 'c++-mode-hook 'lsp)
  (add-hook 'c-mode-hook 'lsp)
  (add-hook 'nix-mode-hook 'lsp)
  (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                    :major-modes '(nix-mode)
                    :server-id 'nix))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

(provide 'setup-lsp)
