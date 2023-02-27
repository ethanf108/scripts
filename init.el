;; global customization options

(setq backup-directory-alist '(("." . "~/.editorbackups"))) ; set editor backups to specific folder
(setq-default buffer-file-coding-system 'utf-8-unix) ; set default encoding to UTF8
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1)) ; disable second (useless) toolbar
(blink-cursor-mode -1) ; turn off the blinking cursor
(setq inhibit-startup-screen t) ; disable startup screen
(line-number-mode t) ; line number
(column-number-mode t) ; column number
(size-indication-mode t) ; where in file
(if (fboundp 'global-display-line-numbers-mode) ; show line numbers everywhere
      (global-display-line-numbers-mode)
    (global-nlinum-mode t))
(fset 'yes-or-no-p 'y-or-n-p) ; enable y/n answers, is this necessary??
(setq minibuffer-eldef-shorten-default 1) ; shorten minibuffer
(setq abbrev-mode nil) ; disable abbrev mode

;; Dired
(setq my-dired-ls-switches "-lpvh --group-directories-first") ; ls command for dired
(setq my-dired-switch 1) ; use the above?

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
                   (dired-sort-other (concat my-dired-ls-switches " -a")))))))

;; packages

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")) ; add MELPA

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t) ; Always download all packages from use-package

(use-package auto-package-update ; automatically updates packages
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(use-package exec-path-from-shell ; loads .bash_profile into this emacs' env. Used mostly to have to correct PATH
  :config
  (when (daemonp) ; only when it's a daemon
    (exec-path-from-shell-initialize)))

; language modes

(use-package go-mode ; golang support
  :config
  (defun go-mode-auto-gofmt ()
    (when (eq major-mode 'go-mode)
      (gofmt-before-save)))
  (add-hook 'before-save-hook #'go-mode-auto-gofmt)) ; auto format using gofmt on save

(use-package rust-mode ; rust support
  :custom
  (rust-format-on-save t "Auto format on save"))

(use-package typescript-mode
  :demand
  :mode "\\.ts\\'" ; auto enable mode on .ts files
  :config
  (define-derived-mode tsx-mode typescript-mode ; define custom major mode called TSX that's just typescript-mode
    "TSX")
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-mode))) ; enable TSX mode for .tsx files

(use-package markdown-mode) ; markdown support

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
  :hook (rust-mode))

(use-package smartparens ; parens / brackets / braces matcher
  :hook (rust-mode java-mode))

(use-package tree-sitter ; sytnax tree / highlighting
  :hook (
	 ((rust-mode) . tree-sitter-mode)
	 ((rust-mode) . tree-sitter-hl-mode)))

(use-package tree-sitter-langs) ; languages for tree-sitter. 66M lol

; themes

(use-package zenburn-theme ; zenburn theme
  :init
  (load-theme 'zenburn t)) ; auto load theme

; useful packages

(use-package transpose-frame) ; M-x transpose-frame RET to "transpose" the frame, in the same way you would transpose a matrix

(use-package latex-preview-pane) ; to work on TeX documents with a live preview on the side

(use-package multiple-cursors ; multiple cursors at once
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  ; honestly, don't know why this is here, looks redundant
  (global-set-key (kbd "C-x O") (lambda ()
                                  (interactive)
                                  (other-window -1))))
