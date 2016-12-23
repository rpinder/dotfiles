;;
;;
;; RPINDER INIT.EL FILE
;;   http://github.com/rpinder
;;
;;

;; last edited: 22/12/2016

;; I know very little elisp

;; Crediting
;;   I will try and credit all the code I paste into this file however sometimes
;;   I will forget or there will be some things I added in before I started
;;   crediting so just tell me if I forget something

;; TODO
;; + setup emacs for c/c++
;;   - semantic autocomplete
;;   - easily switch between header and source file
;;   - fuzzy finder (?)
;; + email inside emacs
;; + set up irc
;;   - facebook messanger bitbee thing
;; + latex environment

;-------------------------------------------------------------------------------

;; remove useless (to me) clutter
;;   I have this here so I don't see them when emacs is loading
(menu-bar-mode -1)
(when (display-graphic-p) ;; these elements don't exist in the terminal emacs
  (tool-bar-mode -1)      ;; so turning them off isn't needed
  (scroll-bar-mode -1))

(setq custom-file "~/.emacs.d/custom.el") ;; I don't want the custom stuff inside this file
(load custom-file)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          AUTOMATIC PACKAGE INSTALLATION
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This code is from the "Automatically installing Packages" section of the
;; "From Vim to Emacs in Fourteen Days article by Arron Bieber posted on May
;; 24th 2015

;; http://blog.aaronbieber.com/2015/05/24/from-vim-to-emacs-in-fourteen-days.html

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it's not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; Make sure to have downloaded archive descriptions
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(package-initialize)

(ensure-package-installed 'evil
                          'evil-surround
                          'ido-vertical-mode
                          'org-bullets
                          'neotree
                          'smex
                          'ido-ubiquitous
                          'flycheck
                          'quickrun
                          'magit
                          'switch-window
                          'rbenv
                          'spacegray-theme
                          'hlinum
                          'pdf-tools
                          'key-chord
                          'winum
                          'which-key
                          'github-browse-file
                          'yasnippet
                          'smooth-scrolling
                          'company
                          'irony
                          'company-irony
                          'company-c-headers
                          'flycheck-irony
                          )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          UI CONFIG
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load-theme 'spacegray t)   ;; loads spacegray theme

(global-linum-mode 1)       ;; enables line numbers in fringe

(setq column-number-mode t) ;; puts column number in the mode line

;; puts a space between number line and window border
(defadvice linum-update-window (around linum-dynamic activate)
  (let* ((w (length (number-to-string
                     (count-lines (point-min) (point-max)))))
         (linum-format (concat " %" (number-to-string w) "d ")))
    ad-do-it))

(setq inhibit-startup-screen t) ;; disables emacs start screen

;; Inactive modeline is darker 
(set-face-foreground 'modeline-inactive "#777777")
(set-face-background 'modeline-inactive "#181b22")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;           CUSTOM FUNCTIONS 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; opens emacs configuration file
(defun open-dotfile () (interactive)
       (find-file "~/dotfiles/emacs/init.el"))

;; opens zsh configuration file
(defun open-zsh () (interactive)
       (find-file "~/dotfiles/.zshrc"))

;; self explanatory
(defun load-emacs () (interactive)
       (load-file "~/.emacs.d/init.el"))

;; this turns off line numbers and line highlighting, and also gets rid of the fringe
(defun setup-eshell ()
  (linum-mode -1)
  (set-window-fringes nil 0 0 )
  (hl-line-mode -1))

;; inserts comment subheadings like the ones in the 'PACKAGE CONFIG' section
;;    This is probably done horribly but I was in a rush and wanted to quickly
;;    have this functuality. I will try and improve this soon
(defun sub-comment ()
  (interactive)
  (let ((x (read-string "Enter comment: ")))
    (message "Commenting %s." x)
    (insert ";;------------------------------------------------\n")
    (insert ";;          ")
    (insert x)
    (insert "\n")
    (insert ";;------------------------------------------------\n")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          HOOKS 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; makes the eshell experience more pleasant
(add-hook 'eshell-mode-hook  'setup-eshell)

;; all programming buffers have line highlighting
(add-hook 'prog-mode-hook (lambda () (hl-line-mode 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          CUSTOM KEYBINDS 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-key global-map (kbd "RET") 'newline-and-indent)

;; C-c o(pen) 
(global-set-key (kbd "C-c o d") 'open-dotfile)
(global-set-key (kbd "C-c o z") 'open-zsh)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          MISCELLANEOUS  
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use spaces for indenting
(setq-default indent-tabs-mode nil)

;; put all backups into one directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; stop emacs from autosaving
(setq auto-save-default nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;          PACKAGE CONFIG  
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;----------------------------------------------------------
;;          COMPANY-MODE
;;----------------------------------------------------------

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(setq company-idle-delay 0.1)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-c-headers))

;;----------------------------------------------------------
;;          EVIL
;;----------------------------------------------------------

(require 'evil)
(evil-mode t)
; I should just use a modeline package
(setq evil-mode-line-format '(before . mode-line-front-space))
(setq evil-normal-state-tag   (propertize " NORMAL  " 'face '((:background "#343d46")))
      evil-emacs-state-tag    (propertize " EMACS   " 'face '((:background "#C189EB")))
      evil-insert-state-tag   (propertize " INSERT  " 'face '((:background "#27AE60")))
      evil-motion-state-tag   (propertize " MOTION  " 'face '((:background "#89EBCA")))
      evil-visual-state-tag   (propertize " VISUAL  " 'face '((:background "#DCA432")))
      evil-replace-state-tag  (propertize " REPLACE " 'face '((:background "#bf616a")))
      evil-operator-state-tag (propertize " NORMAL  " 'face '((:background "#343d46"))))

(require 'evil-surround)
(global-evil-surround-mode 1)

;;----------------------------------------------------------
;;          INTERACTIVELY DO THINGS (ido)
;;----------------------------------------------------------

(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(require 'ido-ubiquitous)
(ido-ubiquitous-mode 1)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;----------------------------------------------------------
;;         NEOTREE 
;;----------------------------------------------------------

(require 'neotree)
(setq neo-theme 'ascii)
(global-set-key "\C-cn" 'neotree-toggle)
(setq neo-smart-open t)
(add-hook 'neotree-mode-hook
          (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;;----------------------------------------------------------
;;         FLYCHECK 
;;----------------------------------------------------------

(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

;;----------------------------------------------------------
;;          TRAMP
;;----------------------------------------------------------

(require 'tramp)

;;----------------------------------------------------------
;;          QUICKRUN
;;----------------------------------------------------------

(require 'quickrun)

;;----------------------------------------------------------
;;          RBENV
;;----------------------------------------------------------

(require 'rbenv)
;; Setting rbenv path
(setenv "PATH" (concat (getenv "HOME") "/.rbenv/shims:" (getenv "HOME") "/.rbenv/bin:" (getenv "PATH")))
(setq exec-path (cons (concat (getenv "HOME") "/.rbenv/shims") (cons (concat (getenv "HOME") "/.rbenv/bin") exec-path)))
(setq rbenv-modeline-function 'rbenv--modeline-plain)

;;----------------------------------------------------------
;;          HLINUM
;;----------------------------------------------------------

(require 'hlinum)
(hlinum-activate)

;;----------------------------------------------------------
;;          KEY-CHORD
;;----------------------------------------------------------

(require 'key-chord)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-define evil-insert-state-map "kj" 'evil-normal-state)

;;----------------------------------------------------------
;;          WINUM
;;----------------------------------------------------------

(require 'winum)
(setq winum-mode-line-position 8)

;; winum-keymap-prefix is currently broken so I'm doing this instead
(global-set-key (kbd "C-c 0") 'winum-select-window-0-or-10)
(global-set-key (kbd "C-c 1") 'winum-select-window-1)
(global-set-key (kbd "C-c 2") 'winum-select-window-2)
(global-set-key (kbd "C-c 3") 'winum-select-window-3)
(global-set-key (kbd "C-c 4") 'winum-select-window-4)
(global-set-key (kbd "C-c 5") 'winum-select-window-5)
(global-set-key (kbd "C-c 6") 'winum-select-window-6)
(global-set-key (kbd "C-c 7") 'winum-select-window-7)
(global-set-key (kbd "C-c 8") 'winum-select-window-8)
(global-set-key (kbd "C-c 9") 'winum-select-window-9)

(winum-mode)

;;----------------------------------------------------------
;;          WHICH-KEY
;;----------------------------------------------------------

(require 'which-key)
(which-key-mode)

;;----------------------------------------------------------
;;          ORG MODE
;;----------------------------------------------------------

(defvar org-log-done t)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;;----------------------------------------------------------
;;          PDF TOOLS
;;----------------------------------------------------------

(pdf-tools-install)

;;----------------------------------------------------------
;;          SWITCH WINDOW
;;----------------------------------------------------------

(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)

;;----------------------------------------------------------
;;          YASNIPPET
;;----------------------------------------------------------

(require 'yasnippet)
(yas-global-mode 1)

;;----------------------------------------------------------
;;          SMOOTH SCROLLING
;;----------------------------------------------------------

(require 'smooth-scrolling)
(smooth-scrolling-mode 1)
(setq smooth-scroll-margin 5)

