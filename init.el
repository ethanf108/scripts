; Ethan Ferguson Custom Scripts

;; emacs customize is gross

(setq custom-file (concat user-emacs-directory "customize.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(setq-default buffer-file-coding-system 'utf-8-unix) ; set default encoding to UTF8

;(setq-default mode-line-format '("L"))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")) ; add MELPA

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t) ; Always download all packages from use-package

;;; emacs configurations

(defun new-temp-buffer ()
  "Create a new temporary buffer and navigate to it."
  (interactive)
  (switch-to-buffer (concat "*" (make-temp-name "scratch") "*")))

(defun new-temp-org-buffer ()
  "Create a new temporary org-mode buffer and navigate to it."
  (interactive)
  (new-temp-buffer)
  (org-mode))

(defun reopen-as-root ()
  (interactive)
  "Reopen current buffer using tramp-sudo"
  (find-alternate-file (concat "/sudo::" buffer-file-name)))

(use-package emacs
  :init
  (blink-cursor-mode -1) ; turn off the blinking cursor
  (menu-bar-mode -1) ; disable menu bar
  (line-number-mode t) ; line number
  (column-number-mode t) ; column number
  (size-indication-mode t) ; where in file
  :bind ("C-x C-k" . kill-this-buffer)
  :bind ("C-c n" . new-temp-buffer)
  :bind ("C-c o" . new-temp-org-buffer)
  :bind ("C-x C-S-s" . reopen-as-root)
  :custom
  (backup-directory-alist '(("." . "~/.editorbackups")) "Set editor backups to specific folder")
  (inhibit-startup-screen t "Disable startup screen")
  (minibuffer-eldef-shorten-default 1 "Shorten minibuffer")
  (abbrev-mode nil "Disable abbrev mode")
  :config
  (setq-default explicit-shell-file-name "/bin/bash")
  (when (fboundp 'tool-bar-mode) (tool-bar-mode -1)) ; disable second (useless) toolbar
  (if (fboundp 'global-display-line-numbers-mode) ; show line numbers everywhere
      (global-display-line-numbers-mode)
    (global-nlinum-mode t))
  (fset 'yes-or-no-p 'y-or-n-p)) ; enable y/n answers, is this necessary??


; Can't use :custom for some reason
(setq my-dired-ls-switches "-lpvh --group-directories-first") ; ls command for dired
(setq my-dired-switch 1) ; Use the above?

(use-package dired
  :ensure nil
  :no-require t
  :config
  
  ; use the right switches?
  (add-hook 'dired-mode-hook
	    (lambda ()
              "Set the right mode for new dired buffers."
              (when (= my-dired-switch 1)
		(dired-sort-other my-dired-ls-switches))))
  
  ; bind M-o to toggle using -a for ls dired
  (add-hook 'dired-mode-hook
	    (lambda ()
              (define-key dired-mode-map (kbd "M-o")
		(lambda ()
                  "Toggle between hide and show."
                  (interactive)
                  (setq my-dired-switch (- my-dired-switch))
                  (if (= my-dired-switch 1)
                      (dired-sort-other my-dired-ls-switches)
                    (dired-sort-other (concat my-dired-ls-switches " -a"))))))))


;; packages to use with use-package
;(use-package delight)

(use-package exec-path-from-shell ; loads .bash_profile into this emacs' env. Used mostly to have to correct PATH
  :config
  (when (daemonp) ; only when it's a daemon
    (exec-path-from-shell-initialize)))

; language modes

(use-package racket-mode)

(use-package cider) ; clojure

(use-package go-mode ; golang support
  :init
  (defun go-mode-auto-gofmt ()
    (when (eq major-mode 'go-mode)
      (gofmt-before-save)))
  :config
  (add-hook 'before-save-hook #'go-mode-auto-gofmt)) ; auto format using gofmt on save

(use-package rust-mode ; rust support
  :custom
  (rust-format-on-save t "Auto format on save"))

(use-package tide
  :after (company flycheck)
  :hook ((typescript-ts-mode . tide-setup)
         (tsx-ts-mode . tide-setup)
         (typescript-ts-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

(defun setup-tide-mode ()
  "Custom setup function for tide mode"
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(setq company-tooltip-align-annotations t)

(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(add-hook 'typescript-ts-mode-hook #'setup-tide-mode)

(use-package typescript-mode
  :demand
  :mode "\\.ts\\'" ; auto enable mode on .ts files
  :config
  (define-derived-mode tsx-mode typescript-mode ; define custom major mode called TSX that's just typescript-mode
    "TSX")
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-mode))) ; enable TSX mode for .tsx files

(use-package markdown-mode ; markdown support
  :mode "\\.md\\'") 

; eglot related packages

(use-package flymake ; error / warning highlighting
  :config
  (define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error))

(use-package eglot ; LSP client, minimal setup
  :hook ((rust-mode js-mode typescript-mode tsx-mode) 
	 . eglot-ensure)
  :custom
  (eglot-confirm-server-initiated-edits . nil)
  :config
  (put 'typescript-react-mode 'eglot-language-id "typescriptreact")
  (add-to-list 'eglot-server-programs `(tsx-mode . ("typescript-language-server" "--stdio"))))

(use-package company ; code competion
  :hook (rust-mode tsx-mode))

(use-package smartparens ; parens / brackets / braces matcher
  :hook (rust-mode java-mode))

(use-package tree-sitter ; sytnax tree / highlighting
  :hook (
	 ((rust-mode) . tree-sitter-mode)
	 ((rust-mode) . tree-sitter-hl-mode)))

(use-package tree-sitter-langs) ; languages for tree-sitter. 66M lol

; themes

(use-package zenburn-theme ; zenburn theme
  :demand
  :init
  (load-theme 'zenburn t)) ; auto load theme

; useful packages

(use-package fireplace)

(use-package transpose-frame ; flip windows in a frame. Custom keybindings
  :config (bind-keys :prefix-map transpose-frame-map
		     :prefix "C-c C-t"
		     ("t" . transpose-frame)
		     ("p" . flip-frame) ; "p" for pitch, rotates over pitch (x) axis
		     ("x" . flip-frame) ; also bind x for above
		     ("y" . flop-frame) ; "y" for yaw / y, flips over yaw (y) axis
		     ("r" . rotate-frame-clockwise) ; r for "right", rotates right
		     ("l" . rotate-frame-anticlockwise) ; l for "left", rotates left
		     ("o" . rotate-frame))) ; r for "rotate", rotates 180 deg

(use-package latex-preview-pane) ; to work on TeX documents with a live preview on the side

(use-package multiple-cursors ; multiple cursors at once
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  ; honestly, don't know why this is here, looks redundant
  (global-set-key (kbd "C-x O") (lambda ()
                                  (interactive)
                                  (other-window -1))))

(use-package projectile
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)
  :custom
  (projectile-project-search-path '("~/proj/") "projectile search paths")
  (projectile-mode-line-prefix " @"))

(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t "cycle vertico n/p"))

(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (orderless-matching-styles '(orderless-regexp orderless-literal orderless-flex))
  (completion-category-overrides '((file (styles basic partial-completion)))))

; put this last so it updates all packages
(use-package auto-package-update ; automatically updates packages
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; preinstalled packages

(use-package eldoc)

(use-package org
  :custom
  (org-src-preserve-indentation t))
(put 'scroll-left 'disabled nil)
