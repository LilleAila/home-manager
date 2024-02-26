;; === Basic configuration ===
;; (setq frame-title-format (format "%s's Emacs" (capitalize user-login-name)))
(setq frame-title-format "%b")
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq inhibit-startup-message t)
(setq initial-buffer-choice t)
(setq initial-scratch-message ";; Scratch Buffer\n\n")
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-auto-revert-mode t)

;; === Disable default UI elements ===
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)

;; === Disable custom-file ===
(setq custom-file (make-temp-file "emacs-custom-"))

(provide 'config-essential)
