(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))

(add-to-list 'default-frame-alist
                       '(font . "DejaVu Sans Mono-12"))

;; org mode
(require 'org)
;(define-key global-map "\C-cl" 'org-store-link)
;(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; Windows
(when (eq system-type 'cygwin)     (load "cygwin-emacs.el"))
(when (eq system-type 'windows-nt) (load "nt-emacs.el"))

; ide
(add-to-list 'load-path "~/.emacs.d/ide")
(load-library "ide.el")

(require 'cl) ; If you don't have it already
(require 'igrep)
(setq igrep-find-prune-clause  "-type d \\( -name RCS -o -name CVS -o -name SCCS -o -name obj \\)")
(setq igrep-find-file-clause "-type f \\! -name \\*\\~ \\! -name \\*\\,v \\! -name s.\\* \\! -name .\\#\\*e \\! -name \\*.keep \\! -name \\*.keep.\\[0-9\\]")

(defun* get-closest-pathname (&optional (file "makefile"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
    (expand-file-name file
              (loop
            for d = default-directory then (expand-file-name ".." d)
            if (file-exists-p (expand-file-name file d))
            return d
            if (equal d root)
            return nil))))

(require 'compile)
(add-hook 'c-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "cd $(dirname %s); x86make -J 8" (get-closest-pathname)))))
(add-hook 'c++-mode-hook (lambda () (set (make-local-variable 'compile-command) (format "cd $(dirname %s); x86make -J 8" (get-closest-pathname)))))

; (c-add-style "hjw"
;   '("bsd"  ; this must be defined elsewhere - it is in cc-modes.el
;   (c-basic-offset . 4)
;   (c-echo-syntactic-information-p . t)
;   (c-comment-only-line-offset . (0 . 0))
;   (c-offsets-alist . (
;     (c                     . c-lineup-C-comments)
;     (statement-case-open   . 0)
;     (case-label            . +)
;     (func-decl-cont        . 0)
;     (arglist-intro         . +)
;     ))
;   ))


; (defconst my-c-lineup-maximum-indent 30)
;  (defun my-c-lineup-arglist (langelem)
;     (let ((ret (c-lineup-arglist langelem)))
;       (if (< (elt ret 0) my-c-lineup-maximum-indent)
;           ret
;         (save-excursion
;           (goto-char (cdr langelem))
;           (vector (+ (current-column) 8))))))

; (defun hjw-c-mode-hook-fn ()
;      ;; use my defined style for all C modules
;      (c-set-style "hjw")
;      ;; never convert leading spaces to tabs
;      (setq indent-tabs-mode nil)
;      (setcdr (assoc 'arglist-cont-nonempty c-offsets-alist)
;              '(c-lineup-gcc-asm-reg my-c-lineup-arglist))
;   )

; (add-hook 'c-mode-hook 'hjw-c-mode-hook-fn)
; (add-hook 'c++-mode-hook 'hjw-c-mode-hook-fn)

(modify-syntax-entry ?_ "w")
(delete-selection-mode 1)

(require 'bs)
(global-set-key (kbd "C-x C-b") 'bs-show)


(defconst my-packages
  '(company
    magit
    ggtags
    helm
    helm-gtags
    function-args
    clean-aindent-mode
    company-c-headers
    igrep
    dtrt-indent
    ws-butler
    yasnippet
    smartparens
    aggressive-indent
    projectile))

(defun install-packages ()
  "Install all required packages."
  (interactive)
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (package my-packages)
    (unless (package-installed-p package)
      (package-install package))))

(install-packages)
