;;; authinfo-color-mode.el --- A simple iteration on `authinfo-mode' that provides some color -*- lexical-binding: t; -*-

;; Copyright (C) 2020 tecosaur

;; Author: TEC <http://github/tecosaur>
;; Maintainer: TEC <tec@tecosaur.com>
;; Created: 22 Oct 2020
;; Modified: October 22, 2020
;; Version: 0.0.1
;; Keywords: authinfo
;; Homepage: https://github.com/tecosaur/authinfo-color-mode
;; Package-Requires: ((emacs "26.3"))

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later versi;;

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more detai;;

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code

(defvar authinfo-color-keywords
  '(("^#.*" . font-lock-comment-face)
    ("^\\(machine\\)[ \t]+\\([^ \t\n]+\\)"
     (1 font-lock-variable-name-face)
     (2 font-lock-builtin-face))
    ("\\(login\\)[ \t]+\\([^ \t\n]+\\)"
     (1 font-lock-comment-delimiter-face)
     (2 font-lock-keyword-face))
    ("\\(password\\)[ \t]+\\([^ \t\n]+\\)"
     (1 font-lock-comment-delimiter-face)
     (2 font-lock-doc-face))
    ("\\(port\\)[ \t]+\\([^ \t\n]+\\)"
     (1 font-lock-comment-delimiter-face)
     (2 font-lock-type-face))
    ("\\([^ \t\n]+\\)[, \t]+\\([^ \t\n]+\\)"
     (1 font-lock-constant-face)
     (2 nil))))

(defun authinfo-color--hide-passwords (start end)
  "Just `authinfo--hide-passwords' with a different color face overlay."
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char start)
      (while (re-search-forward "\\bpassword +\\([^\n\t ]+\\)"
                                nil t)
        (let ((overlay (make-overlay (match-beginning 1) (match-end 1))))
          (overlay-put overlay 'display (propertize "****"
                                                    'face 'font-lock-doc-face))
          (overlay-put overlay 'reveal-toggle-invisible
                       #'authinfo-color--toggle-display))))))

(defun authinfo-color--toggle-display (overlay hide)
  "Just `authinfo--toggle-display' with a different color face overlay."
  (if hide
      (overlay-put overlay 'display (propertize "****" 'face 'font-lock-doc-face))
    (overlay-put overlay 'display nil)))

(defvar authinfo-hide-passwords t
  "Whether to hide passwords in authinfo.")

;;;###autoload
(define-derived-mode authinfo-color-mode fundamental-mode "Authinfo"
  "Major mode for editing .authinfo files.

Like `fundamental-mode', just with color and passoword hiding."
  (font-lock-add-keywords nil authinfo-color-keywords)
  (setq-local comment-start "#")
  (setq-local comment-end "")
  (when authinfo-hide-passwords
    (authinfo-color--hide-passwords (point-min) (point-max))
    (reveal-mode)))

(provide 'authinfo-color-mode)

;;; authinfo-color-mode.el ends here
