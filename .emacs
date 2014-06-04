;; Start CEDET early, so nothing else bootstraps it
(load-file "~/.emacs.d/minimial-cedet-config.el")

(server-start)

;; Nice file autocompletes, etc
(load-file "~/.emacs.d/better-defaults.el")

;; So DELETE key behaves nicely
(global-set-key (kbd "<delete>") '(lambda (n) (interactive "p") (if (use-region-p) (delete-region (region-beginning) (region-end)) (delete-char n))))

(cua-mode 1)
;; Remap cua rectangle select to avoid cedet completion
(global-set-key (kbd "<s-return>") 'cua-set-rectangle-mark)

;; collect less frequently
(setq gc-cons-threshold 20000000)

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(require `package)
(add-to-list `package-archives
  `("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)


;; Retreated from icicles
(require 'ido)
    (ido-mode t)
(require 'flx-ido)

(require 'delsel)

(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-use-faces nil)

;; window rotations
(load-file "~/.emacs.d/transpose-frame.elc")

(setq x-select-enable-clipboard t)

;; emacs, stop being a jerk...
(require 'smooth-scrolling)


;; Somehow emacs keeps seeing a fresh save as changed when building, so becomes intolerably naggy
;; auto-touch from issues makefile makes life intolerably naggy
;; (global-auto-revert-mode 1)
(defun ask-user-about-supersession-threat (fn)
  "blatantly ignore files that changed on disk"
  )


;; autosave before compiling
 (setq compilation-ask-about-save nil)

;; (defun my-compilation-mode-hook-changes ()
;;   (define-key compilation-mode-map (kbd "M-p") 'compilation-previous-error)
;;   (define-key compilation-mode-map (kbd "M-n") 'compilation-next-error))

;; (add-hook 'compilation-mode-hook 'my-compilation-mode-hook-changes)


;;  (defun my-compilation-hook () 
;;    (ergoemacs-define-overrides
;;     (define-key compilation-mode-map (kbd "M-n") 'next-error)
;;     (define-key compilation-mode-map (kbd "M-p") 'previous-error))
;; With the wide monitor the default horizontal split works better
;;   "Make sure that the compile window is splitting vertically"
;;    (progn
;;      (if (not (get-buffer-window "*compilation*"))
;;         (progn
;;	    (split-window-vertically)
;;	    )
;;	  )
;;      )
;;  )
;;  (add-hook 'compilation-mode-hook 'my-compilation-hook)


;; I-search with initial contents.
;; original source: http://platypope.org/blog/2007/8/5/a-compendium-of-awesomeness
(defvar isearch-initial-string nil)

(defun isearch-set-initial-string ()
  (remove-hook 'isearch-mode-hook 'isearch-set-initial-string)
  (setq isearch-string isearch-initial-string)
  (isearch-search-and-update))

(defun isearch-forward-at-point (&optional regexp-p no-recursive-edit)
  "Interactive search forward for the symbol at point."
  (interactive "P\np")
  (if regexp-p (isearch-forward regexp-p no-recursive-edit)
    (let* ((end (progn (skip-syntax-forward "w_") (point)))
           (begin (progn (skip-syntax-backward "w_") (point))))
      (if (eq begin end)
          (isearch-forward regexp-p no-recursive-edit)
        (setq isearch-initial-string (buffer-substring begin end))
        (add-hook 'isearch-mode-hook 'isearch-set-initial-string)
        (isearch-forward regexp-p no-recursive-edit)))))

  (global-set-key [f8] 'isearch-forward-at-point)



;(add-to-list `load-path "~/.emacs.d/ergoemacs-mode")
;(require 'ergoemacs-mode)

;(setq ergoemacs-theme nil) ;; Uses Standard Ergoemacs keyboard theme
;(setq ergoemacs-keyboard-layout "us") ;; Assumes QWERTY keyboard layout
;(ergoemacs-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-normal-cursor-color "orange")
 '(cua-read-only-cursor-color "yellow")
 '(custom-enabled-themes (quote (misterioso)))
 '(custom-safe-themes (quote ("a16346f0185035dd07b203e70294ab533e8be992d9e7a5d5e8800ede264e0e25" default)))
 '(delete-selection-mode t)
 '(ede-project-directories (quote ("/home/thomasg/code/cci/examples" "/home/thomasg/code/cci/api" "/home/thomasg/code/cci/gs_param_implementation")))
; '(ergoemacs-ctl-c-or-ctl-x-delay 0.5)
; '(ergoemacs-handle-ctl-c-or-ctl-x (quote both))
; '(ergoemacs-keyboard-layout "gb")
; '(ergoemacs-mode-used "5.14.01-0")
; '(ergoemacs-smart-paste nil)
; '(ergoemacs-theme nil)
; '(ergoemacs-use-menus t)
 '(menu-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(visible-cursor t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Droid Sans Mono" :foundry "unknown" :slant normal :weight normal :height 90 :width normal)))))


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


  (global-set-key [f9] 'my-compile)
  (global-set-key [f11] 'previous-error)
  (global-set-key [f12] 'next-error)

;;(defadvice previous-error (around my-previous-error activate)
;;  (let ((display-buffer-overriding-action '(display-buffer-reuse-window (inhibit-same-window . nil))))
;;    ad-do-it))
;;(defadvice next-error (around my-next-error activate)
;;  (let ((display-buffer-overriding-action '(display-buffer-reuse-window (inhibit-same-window . nil))))
;;    ad-do-it))

;; ;; Icicles setup - deliberately late
;; (add-to-list `load-path "~/.emacs.d/elpa/icicles-20140310.8")
;; (require 'icicles)
;; (icy-mode 1)
;; (setq icicle-incremental-completion "t")

;; ;; CTRL-TAB buffer switching
;; (global-set-key [C-tab] (quote icicle-buffer))


;; ;; ;; CTRL-TAB buffer switching
;; (global-set-key (kbd "<C-tab>") 'my-switch-buffer)
;; (defun my-switch-buffer ()
;;   "Switch buffers, but don't record the change until the last one."
;;   (interactive)
;;   (let ((blist (copy-sequence (buffer-list)))
;;         current
;;         (key-for-this (this-command-keys))
;;         (key-for-this-string (format-kbd-macro (this-command-keys)))
;;         done)
;;     (while (not done)
;;       (setq current (car blist))
;;       (setq blist (append (cdr blist) (list current)))
;;       (when (and (not (get-buffer-window current))
;;                  (not (minibufferp current)))
;;         (switch-to-buffer current t)
;;         (message "Type %s to continue cycling" key-for-this-string)
;;         (when (setq done (not (equal key-for-this (make-vector 1 (read-event)))))
;;           (switch-to-buffer current)
;;           (clear-this-command-keys t)
;;           (setq unread-command-events (list last-input-event)))))))

;; ;; ;; CTRL-TAB buffer switching
(require 'iflipb)
(setq iflipb-wrap-around t)
(global-set-key (kbd "<C-tab>") 'iflipb-next-buffer)
(global-set-key
 (if (featurep 'xemacs) (kbd "<C-iso-left-tab>") (kbd "<C-S-iso-lefttab>"))
 'iflipb-previous-buffer)

(set-cursor-color "gold")

;; STOP next-error visiting "included from"s
;;
;; This element is what controls the matching behaviour: according to
;; `compilation-error-regexp-alist` doc, it means if subexpression 4 of the
;; regexp matches, it's a warning, if subexpression 5 matches, it's an info.
(nth 5 (assoc 'gcc-include compilation-error-regexp-alist-alist))
(4 . 5)
;; We could try and tinker with the regexp, but it's simpler to just set it as
;; "always match as info".
(setcar (nthcdr 5 (assoc 'gcc-include compilation-error-regexp-alist-alist)) 0)


