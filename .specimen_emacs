;; TRYING WITHOUT CEDET TO SEE IF BIG NAVIGATION SNOOZES CEASE
;; Start CEDET early, so nothing else bootstraps it
;;(load-file "~/.emacs.d/minimial-cedet-config.el")

(server-start)

;; Nice file autocompletes, etc
(load-file "~/.emacs.d/better-defaults.el")

;; So DELETE key behaves nicely
(global-set-key (kbd "<delete>") '(lambda (n) (interactive "p") (if (use-region-p) (delete-region (region-beginning) (region-end)) (delete-char n))))

;; option as ALT on Mac
(set-keyboard-coding-system nil)

;; Make shifted direction keys work on the Linux console or in an xterm
(when (member (getenv "TERM") '("linux" "xterm"))
  (dolist (prefix '("\eO" "\eO1;" "\e[1;"))
    (dolist (m '(("2" . "S-") ("3" . "M-") ("4" . "S-M-") ("5" . "C-")
                 ("6" . "S-C-") ("7" . "C-M-") ("8" . "S-C-M-")))
      (dolist (k '(("A" . "<up>") ("B" . "<down>") ("C" . "<right>")
                   ("D" . "<left>") ("H" . "<home>") ("F" . "<end>")))
        (define-key function-key-map
                    (concat prefix (car m) (car k))
                    (read-kbd-macro (concat (cdr m) (cdr k))))))))

;; No dangling whitespace
(add-hook 'before-save-hook
          'delete-trailing-whitespace)
;;(cua-mode 1)
;; Remap cua rectangle select to avoid cedet completion
(global-set-key (kbd "<s-return>") 'cua-set-rectangle-mark)
(global-set-key (kbd "C-<prior>") 'beginning-of-buffer)
(global-set-key (kbd "C-<next>") 'end-of-buffer)

(define-key input-decode-map "\e[1;2D" [S-left])
(define-key input-decode-map "\e[1;2C" [S-right])
(define-key input-decode-map "\e[1;2B" [S-down])
(define-key input-decode-map "\e[1;2A" [S-up])
(define-key input-decode-map "\e[1;2F" [S-end])
(define-key input-decode-map "\e[1;2H" [S-home])

;; collect less frequently
(setq gc-cons-threshold 20000000)

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(require `package)
;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(add-to-list 'package-archives  '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; IDE
;;(load-file "~/.emacs.d/core-c.el")

;; autocomplete
;;(add-to-list 'load-path (concat myoptdir "AC"))
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "AC/ac-dict")

(require 'auto-complete-clang)

(cua-mode t)

(command-execute 'xterm-mouse-mode)

(setq ac-auto-start nil)
(setq ac-quick-help-delay 0.5)
;; (ac-set-trigger-key "TAB")
;; (define-key ac-mode-map  [(control tab)] 'auto-complete)
(global-set-key (kbd "<s-tab>") 'auto-complete)
(defun my-ac-config ()
  (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  ;; (add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
  (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
  (add-hook 'css-mode-hook 'ac-css-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))
(defun my-ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
(add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
;; ac-source-gtags
(my-ac-config)

;; Retreated from icicles
(require 'ido)
    (ido-mode t)
(require 'flx-ido)

(require 'delsel)

(require 'highlight-symbol)
(global-set-key (kbd "<f7>") 'highlight-symbol-at-point)
(global-set-key (kbd "<f8>") 'highlight-symbol-next)
(global-set-key (kbd "<s-f8>") 'highlight-symbol-prev)

;; keep accidentally going into overwrite mode
(global-set-key (kbd "<insert>") 'ignore)

(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-use-faces nil)

;; window rotations
(load-file "~/.emacs.d/transpose-frame.el")

(setq x-select-enable-clipboard t)

;; emacs, stop being a jerk...
(require 'smooth-scrolling)

;; popwin for temp buffers
(require 'popwin)
(push '("\*anything*" :regexp t :height 20) popwin:special-display-config)

(require 'win-switch)
(windmove-default-keybindings 'meta)
;(win-switch-setup-keys-ijkl "\C-xo")

(require 'fill-column-indicator)

;; Somehow emacs keeps seeing a fresh save as changed when building, so becomes intolerably naggy
;; auto-touch from issues makefile makes life intolerably naggy
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)


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

;;  (global-set-key [f8] 'isearch-forward-at-point)



;;(add-to-list `load-path "~/.emacs.d/ergoemacs-mode")
;;(require 'ergoemacs-mode)

;;(setq ergoemacs-theme nil) ;; Uses Standard Ergoemacs keyboard theme
;;(setq ergoemacs-keyboard-layout "us") ;; Assumes QWERTY keyboard layout
;;(ergoemacs-mode 1)
;;(custom-set-variables
;; ;; custom-set-variables was added by Custom.
;; ;; If you edit it by hand, you could mess it up, so be careful.
;; ;; Your init file should contain only one such instance.
;; ;; If there is more than one, they won't work right.
;; '(cua-normal-cursor-color "orange")
;; '(cua-read-only-cursor-color "yellow")
;; '(custom-enabled-themes (quote (misterioso)))
;; '(custom-safe-themes (quote ("a16346f0185035dd07b203e70294ab533e8be992d9e7a5d5e8800ede264e0e25" default)))
;; '(delete-selection-mode t)
;; '(ede-project-directories (quote ("/home/thomasg/code/cci/examples" "/home/thomasg/code/cci/api" "/home/thomasg/code/cci/gs_param_implementation")))
;; '(ergoemacs-ctl-c-or-ctl-x-delay 0.5)
;; '(ergoemacs-handle-ctl-c-or-ctl-x (quote both))
;; '(ergoemacs-keyboard-layout "gb")
;; '(ergoemacs-mode-used "5.14.01-0")
;; '(ergoemacs-smart-paste nil)
;; '(ergoemacs-theme nil)
;; '(ergoemacs-use-menus t)
;; '(menu-bar-mode nil)
;; '(printer-name "lj42-o34")
;; '(ps-printer-name nil)
;; '(show-paren-mode t)
;; '(tool-bar-mode nil)
;; '(visible-cursor t))


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
(global-set-key (kbd "C-q") 'iflipb-next-buffer)
(global-set-key
 (if (featurep 'xemacs) (kbd "<C-iso-left-tab>") (kbd "<C-S-iso-lefttab>"))
 'iflipb-previous-buffer)

(set-cursor-color "gold")

;; STOP next-error visiting "included from"s
;;
;; This element is what controls the matching behaviour: according to
;; `compilation-error-regexp-alist` doc, it means if subexpression 4 of the
;; regexp matches, it's a warning, if subexpression 5 matches, it's an info.
;;(nth 5 (assoc 'gcc-include compilation-error-regexp-alist-alist))
;;(4 . 5)
;; We could try and tinker with the regexp, but it's simpler to just set it as
;; "always match as info".
;(setcar (nthcdr 5 (assoc 'gcc-include compilation-error-regexp-alist-alist)) 0)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(auto-revert-remote-files t)
 '(cmake-ide-build-dir "/space/user/thomasg/msm/smc-compiler/build/compiler")
 '(custom-enabled-themes (quote (manoj-dark)))
 '(custom-safe-themes
   (quote
    ("a16346f0185035dd07b203e70294ab533e8be992d9e7a5d5e8800ede264e0e25" default)))
 '(package-selected-packages
   (quote
    (lsp-mode gnu-elpa-keyring-update magit-gerrit company-c-headers rtags win-switch smooth-scrolling popwin magit-gitflow llvm-mode irony iflipb highlight-symbol flx-ido fill-column-indicator ergoemacs-mode dired-details+ auto-complete-clang ag)))
 '(tab-width 2)
 '(xterm-mouse-mode t))
(put 'set-goal-column 'disabled nil)

; Magit
;(require 'magit-gerrit)
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; recent files
(desktop-save-mode 1)
