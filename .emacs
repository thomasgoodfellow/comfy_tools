(server-start)

;; Start CEDET early, so nothing else bootstraps it
(load-file "~/.emacs.d/minimial-cedet-config.el")

;; Nice file autocompletes, etc
(load-file "~/.emacs.d/better-defaults.el")

;; So DELETE key behaves nicely
(global-set-key (kbd "<delete>") '(lambda (n) (interactive "p") (if (use-region-p) (delete-region (region-beginning) (region-end)) (delete-char n))))

;; CTRL-TAB buffer switching
(global-set-key [C-tab] (quote ido-switch-buffer))

(require 'package)
(add-to-list `package-archives
  `("melpa" . "http://melpa.milkbox.net/packages/") t)

(setq x-select-enable-clipboard t)


;; (defun my-compilation-mode-hook-changes ()
;;   (define-key compilation-mode-map (kbd "M-p") 'compilation-previous-error)
;;   (define-key compilation-mode-map (kbd "M-n") 'compilation-next-error))

;; (add-hook 'compilation-mode-hook 'my-compilation-mode-hook-changes)


(add-to-list `load-path "~/.emacs.d/ergoemacs-mode")
(require 'ergoemacs-mode)

(setq ergoemacs-theme nil) ;; Uses Standard Ergoemacs keyboard theme
(setq ergoemacs-keyboard-layout "us") ;; Assumes QWERTY keyboard layout
(ergoemacs-mode 1)
(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
 '(delete-selection-mode t)
 '(ede-project-directories (quote ("/home/thomasg/code/cci/examples" "/home/thomasg/code/cci/api" "/home/thomasg/code/cci/gs_param_implementation")))
 '(ergoemacs-ctl-c-or-ctl-x-delay 0.2)
 '(ergoemacs-handle-ctl-c-or-ctl-x (quote both))
 '(ergoemacs-keyboard-layout "gb")
 '(ergoemacs-mode-used "5.14.01-0")
 '(ergoemacs-smart-paste nil)
 '(ergoemacs-theme nil)
 '(ergoemacs-use-menus t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)


;; Nicer source handling for compile
  (defun my-compile ()
      "Run compile and resize the compile window"
      (interactive)
      (progn
        (call-interactively 'compile)
        (setq cur (selected-window))
        (setq w (get-buffer-window "*compilation*"))
        (select-window w)
        (setq h (window-height w))
;        (shrink-window (- h 10))
        (select-window cur)
        )
    )

  (defun my-compilation-hook () 
    (message "my-compilation-hook")
    (define-key compilation-mode-map (kbd "M-n") goto-map)
    (define-key compilation-mode-map (kbd "M-n") 'next-error)
    (define-key compilation-mode-map (kbd "M-p") 'previous-error)
;; With the wide monitor the default horizontal split works better
;;   "Make sure that the compile window is splitting vertically"
;;    (progn
;;      (if (not (get-buffer-window "*compilation*"))
;;         (progn
;;	    (split-window-vertically)
;;	    )
;;	  )
;;      )
  )

  (add-hook 'compilation-mode-hook 'my-compilation-hook)
  (global-set-key [f9] 'my-compile)
  (global-set-key [f11] 'previous-error)
  (global-set-key [f12] 'next-error)

(defadvice previous-error (around my-previous-error activate)
  (let ((display-buffer-overriding-action '(display-buffer-reuse-window (inhibit-same-window . nil))))
    ad-do-it))
(defadvice next-error (around my-next-error activate)
  (let ((display-buffer-overriding-action '(display-buffer-reuse-window (inhibit-same-window . nil))))
    ad-do-it))

