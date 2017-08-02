;; package repository

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;; My global bindings
(global-set-key (kbd "M-S-<") 'beginning-of-buffer)
(global-set-key (kbd "M-S->") 'end-of-buffer)
(global-set-key (kbd "C-x O") 'previous-multiframe-window)
;; end global bindings

;;; Code:
(package-initialize)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
;; end packakge repository


;; General Look and Feel
(load-theme 'monokai-alt)
(set-default-font "-PfEd-DejaVu Sans Mono-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1" t t)
(set-default-font "-PfEd-DejaVu Sans Mono-normal-normal-normal-*-11-*-*-*-m-0-iso10646-1" t t)
;;(set-default-font "-ADBO-Source Code Pro-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1" t t)
;;(set-default-font "-ADBO-Source Code Pro-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1" t t)
;;(set-default-font "-APPL-Monaco-normal-normal-normal-*-12-*-*-*-*-0-iso10646-1" t t)
(menu-bar-mode -1)
(tool-bar-mode -1)
;; End General Look and Feel


;; global modes
(setq-default truncate-lines 1)
;; global-modes

;; compilation mode hook
(defun my-compilation-mode-hook ()
  (setq truncate-lines -1)
  )
(add-hook 'compilation-mode-hook 'my-compilation-mode-hook)
;; compilation mode hook

;; Irony Mode for c/c++ completion
;;; This stuff depends on bear to generate a compilation database.
;;; make initial compilation database with "bear make"
;;; You can add this to a project director:
;;; ((nil . ((compile-command . "bear -a make"))))
;; (add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'linum-mode)

;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;;               (ggtags-mode 1))))

;; (defun my-irony-mode-hook ()
;;   (define-key irony-mode-map
;;       [remap completion-at-point] 'counsel-irony)
;;   (define-key irony-mode-map
;;     [remap complete-symbol] 'counsel-irony))

;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;; End Irony Mode


;; c++ stuff
(defun my-c++-mode-hook ()
  ;; rtags
  (rtags-start-process-unless-running)
  (setq rtags-autostart-diagnostics t)
  (setq rtags-completions-enabled t)
  (rtags-enable-standard-keybindings)

  ;; company
  (global-company-mode 1)
  (push 'company-rtags company-backends)
  (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
  
  ;; (irony-mode 1)
  ;;(flycheck-mode 1)
  (linum-mode 1)
  ;; (eval-after-load 'company
  ;;   '(add-to-list 'company-backends 'company-irony))

  ;; (eval-after-load 'flycheck
  ;;   '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

  ;; (lambda ()
  ;;   (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
  ;;     (ggtags-mode 1)))


  ;; keybindings
  (global-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
  (global-set-key (kbd "M-,") 'rtags-location-stack-back)
  
  (global-set-key (kbd "<f12>") 'compile)
  (global-set-key (kbd "<f10>") 'gdb-many-windows)
  (global-set-key (kbd "<f9>") 'ff-find-other-file)

  (c-set-offset 'innamespace 0)
  )

(add-hook 'c++-mode-hook 'my-c++-mode-hook)
;;

;; gdb
(setq gdb-show-main t)

;; override this function to customize gdb window setup
(defun gdb-setup-windows ()
  "Layout the window pattern for option `gdb-many-windows'."
  (gdb-get-buffer-create 'gdb-locals-buffer)
  (gdb-get-buffer-create 'gdb-stack-buffer)
  (gdb-get-buffer-create 'gdb-breakpoints-buffer)
  (set-window-dedicated-p (selected-window) nil)
  (switch-to-buffer gud-comint-buffer)
  (delete-other-windows)
  (let ((win0 (selected-window))
        (win1 (split-window nil ( / ( * (window-height) 3) 4)))
        (win2 (split-window nil ( / (window-height) 3)))
        (win3 (split-window-right)))
    (gdb-set-window-buffer (gdb-locals-buffer-name) nil win3)
    (select-window win2)
    (set-window-buffer
     win2
     (if gud-last-last-frame
         (gud-find-file (car gud-last-last-frame))
       (if gdb-main-file
           (gud-find-file gdb-main-file)
         ;; Put buffer list in window if we
         ;; can't find a source file.
         (list-buffers-noselect))))
    (setq gdb-source-window (selected-window))
    (let ((win4 (split-window-right)))
      (gdb-set-window-buffer
       (gdb-get-buffer-create 'gdb-inferior-io) nil win4))
    (select-window win1)
    (gdb-set-window-buffer (gdb-stack-buffer-name))
    (let ((win5 (split-window-right)))
      (gdb-set-window-buffer (if gdb-show-threads-by-default
                                 (gdb-threads-buffer-name)
                               (gdb-breakpoints-buffer-name))
                             nil win5))
    (select-window win0)))




;; custom set variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("eea01f540a0f3bc7c755410ea146943688c4e29bea74a29568635670ab22f9bc" "525cf5e455ac1c31b2c32ea4f71954e792dbbeadf5fcb28393167f6e60107294" "87233846530d0b2c50774c74c4aca06a1472504c63ccd4ab2b1021b3e56a69e9" default)))
 '(gdb-many-windows t)
 '(package-selected-packages
   (quote
    (flycheck-rtags company-rtags xah-find anything projectile irony irony-eldoc rtags monokai-alt-theme)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; end custom set variables


;; my custom functions
(defun my-set-4k ()
  (interactive)
  (set-default-font "-PfEd-DejaVu Sans Mono-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1" t t)  
  )

(defun my-set-1080 ()
  (interactive)
  (set-default-font "-PfEd-DejaVu Sans Mono-normal-normal-normal-*-11-*-*-*-m-0-iso10646-1" t t)  
  )

;;; my general keybindings
(global-set-key (kbd "<f1>") 'anything)
;;; .emacs ends here
