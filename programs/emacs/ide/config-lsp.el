(use-package lsp-mode
	:commands (lsp lsp-deferred)
	:custom (lsp-keymap-prefix "C-c l")
	:config
	(lsp-enable-which-key-integration t)
)

(use-package company
	:after lsp-mode
	:hook (lsp-mode . company-mode)
	:bind (:map company-active-map
					("<tab>" . company-complete-selection))
			  (:map lsp-mode-map
					("<tab>" . company-indent-or-complete-common))
	:custom
	(company-minimum-prefig-length 1)
	(company-idle-delay 0.0)
)

(use-package company-box
	:hook (company-mode . company-box-mode)
)

(use-package undo-tree
  :init
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  :config
  (global-undo-tree-mode))

(use-package typescript-mode
	:mode "\\.ts\\'"
	:hook (typescript-mode . lsp-deferred)
	:config
	(setq typescript-indent-level 2)
)

(provide 'config-lsp)
