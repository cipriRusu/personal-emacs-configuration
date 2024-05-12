;; Set up package archives
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Ensure 'use-package' is installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Clang formatter for C files
;; For this command to work correctly you need to have clang-format installed 
(defun format-c-files ()
  (interactive)
  (let ((default-directory default-directory))
    (shell-command (format "clang-format -i %s*" default-directory))))

;; Python formatter
;; For this command to work correctly you need to have python-black installed
(defun format-python-files ()
  (interactive)
  (let ((default-directory default-directory))
    (shell-command (format "black %s*" default-directory))))

;;To debug python you need to run realgud:pdb and then use the console. Type help to see all the commands available
(use-package realgud)

;;Install move-text package and map commands to Ctrl+j/k
(unless (package-installed-p 'move-text)
  (package-refresh-contents)
  (package-install 'move-text))
(use-package move-text)

(global-set-key (kbd "C-j") 'move-text-up)
(global-set-key (kbd "C-k") 'move-text-down)

;; Basic UI customizations
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

(set-frame-parameter nil 'alpha-background 50) ;For current frame
(add-to-list 'default-frame-alist '(alpha-background . 50)) ;For all new frames henceforth

;; Reload changed files in buffers
(global-auto-revert-mode t)

;; Evil mode for Vim keybindings
(use-package evil
  :config
  (evil-mode 1))

;; Theme
(use-package modus-themes
  :config
  (load-theme 'modus-operandi t))

;; JavaScript and TypeScript setup
(use-package web-mode
  :mode (("\\.jsx?\\'" . web-mode)
         ("\\.tsx\\'" . web-mode))
  :config
  (setq web-mode-content-types-alist
        '(("jsx" . "\\.js[x]?\\'")
          ("tsx" . "\\.tsx\\'")))
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-script-padding 2
        web-mode-style-padding 2))

;; LSP for JavaScript and TypeScript
(use-package lsp-mode
  :hook ((web-mode . lsp-deferred))
  :commands lsp
  :config
  (setq lsp-prefer-flymake nil))

;; Company mode for autocompletion
(use-package company
  :hook (web-mode . company-mode)
  :config
  (setq company-tooltip-align-annotations t))

;; Prettier for code formatting
(use-package prettier-js
  :hook (web-mode . prettier-js-mode))

;; Treemacs for project navigation
(use-package treemacs
  :config
  (setq treemacs-width 30
        treemacs-height 40
        treemacs-theme "Material"
        treemacs-icon-theme "all-the-icons"
        treemacs-git-mode 'simple
        treemacs-project-follow-mode t)
  (add-hook 'treemacs-mode-hook (lambda () (treemacs-resize-icons 16)))
  (global-set-key (kbd "C-c t") 'treemacs))

;; Debugging with dap-mode
(use-package dap-mode
  :config
  (require 'dap-chrome))

;;Next.js specific configuration
(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (setq js-indent-level 2))

(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))

;; Optional: Helm for improved navigation
(use-package helm
  :config (helm-mode))

;; Optional: Projectile for project management
(use-package projectile
  :config (projectile-mode))

;; Optional: Helm Projectile for Helm integration with Projectile
(use-package helm-projectile
  :config (helm-projectile-on))

;; Org mode styling for header bullets
(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

;; Optional: Neotree for file tree navigation
(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle))

(use-package typescript-mode
  :config (typescript-mode))

;; TypeScript and JSX setup with web-mode
(use-package web-mode
  :mode (("\\.tsx\\'" . web-mode))
  :config
  ;; Adjust indentation
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-script-padding 2
        web-mode-style-padding 2)
  ;; Associate js2-mode with JavaScript blocks in web-mode
  (setq web-mode-content-types-alist '(("jsx" . "\\.tsx\\'")))
  (add-to-list 'web-mode-engines-alist '("jsx" . "js2-mode"))
  ;; Enable auto-closing and auto-pairing
  (setq web-mode-enable-auto-closing t
        web-mode-enable-auto-pairing t)
  ;; Enable CSS colorization
  (setq web-mode-enable-css-colorization t))

;; Set up js2-mode for JavaScript syntax highlighting
(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (setq js-indent-level 2))

;; Associate web-mode with HTML files
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; For debugging to work correctly using React/Next, Chrome debugger needs to be installed manually from
;; https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome
;; and added manually to the following path: /home/[username]/.emacs.d/.extension/vscode/msjsdiag.debugger-for-chrome
;; because the extension is not installed by dap-chrome correctly

(use-package dap-mode
  :after lsp-mode
  :config
  (require 'dap-chrome)
  (dap-register-debug-template
   "Next.js"
   (list :type "chrome"
         :request "launch"
         :name "Launch Next.js"
         :url "http://localhost:5173"
         :webRoot "${workspaceFolder}"
	 :runtimeExecutable "~/usr/bin/google-chrome"
         :sourceMaps t)))

(require 'dap-node)

;; Set Startup theme
(load-theme 'modus-vivendi t)

;; Run treemacs on startup
(add-hook 'emacs-startup-hook 'treemacs)

;;Org mode normalize Tab usage after adding Evil mode
(with-eval-after-load 'evil-maps (define-key evil-motion-state-map (kbd "TAB") nil))

;;Org mode evaluator for python blocks
(defun org-babel-execute:python (body params)
  "Execute a block of Python code with org-babel."
  (let* ((result-params (cdr (assoc :result-params params)))
         (tmp-file (org-babel-temp-file "python-"))
         (cmd (format "%s %s" (or (cdr (assoc :python params)) "python") tmp-file)))
    (with-temp-file tmp-file
      (insert body))
    (message cmd)
    (if (string= (car (member "output" result-params)) "scalar")
        (org-babel-eval cmd "")
      (let ((result (org-babel-eval cmd "")))
        (if (string= (car (member "verbatim" result-params)) "yes")
            (org-babel-trim (substring-no-properties result))
          result)))))

;; Org mode function for custom execution of JS
(defun org-babel-execute:js (body params)
  "Execute a block of JavaScript code with org-babel."
  (let* ((script-file (org-babel-temp-file "js-"))
         (cmd (format "node %s" script-file)))
    (with-temp-file script-file
      (insert body))
    (org-babel-eval cmd "")
    ))

;; Enable JavaScript support in Org Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((js . t)))

;; Configuration for C LSP Configuration
(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;;sample helm configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

;;To have cpptools available you need to run dap-cpptools-setup on initial load 
(require 'dap-cpptools)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0f76f9e0af168197f4798aba5c5ef18e07c926f4e7676b95f2a13771355ce850" default))
 '(org-agenda-files '("~/Documents/MyStuff"))
 '(package-selected-packages
   '(move-text prettier realgud-lldb realgud typescript-mode ob-ipython org-bullets neotree helm-projectile projectile helm js2-mode dap-mode treemacs prettier-js company lsp-mode web-mode modus-themes evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "black")))))
(put 'upcase-region 'disabled nil)
