;;; poly-erb.el --- Polymode for erb -*- lexical-binding: t -*-
;;
;; Author: Siavash Sajjadi and Vitalie Spinu
;; Maintainer: Vitalie Spinu
;; Copyright (C) 2018
;; Version: 0.2
;; Package-Requires: ((emacs "25") (polymode "0.2"))
;; URL: https://github.com/polymode/poly-erb
;; Keywords: emacs
;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This file is *NOT* part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;; Due to unprotected HTML indent which parses ruby code for angle brackets when
;; ruby code contains such brakets (inequality signs) some lines might not be
;; indented correctly. Trivial fix is to either add -indent or +indent cookie on
;; a line, or add matching angle brakets in ruby comments.

(require 'polymode)
(require 'ruby-mode)
(require 'regexp-opt)

(defvar poly-erb-cond-end-regexp
  (concat "[ \t]*" (regexp-opt '("end" "else" "elsif" "when"))))
(defvar poly-erb-cond-beg-regexp
  (concat "\\(.* do\\)\\|[ \t]*" (regexp-opt '("when" "if" "else" "elsif" "unless"
                                               "for" "while" "def" "class"))))

(defun poly-erb-post-indent-offset ()
  "Compute the indent offset of the line following ruby tail."
  (let ((bol (point-at-bol)))
    (pm-goto-span-of-type 'body -1)
    (goto-char (max bol (point))))
  (goto-char (max (point-at-bol) (point)))
  (if (looking-at-p poly-erb-cond-beg-regexp)
      ruby-indent-level
    0))

(defun poly-erb-pre-indent-offset ()
  "Compute the indent offset of head ruby line."
  (let ((eol (point-at-eol)))
    (pm-goto-span-of-type 'body 1)
    (if (> (point) eol)
        0
      (if (looking-at-p poly-erb-cond-end-regexp)
          (- ruby-indent-level)
        0))))

(define-obsolete-variable-alias 'pm-inner/erb 'poly-erb-innermode "v0.2")
(define-innermode poly-erb-innermode
  :mode 'ruby-mode
  :head-matcher  "\"?\<\% *[-=]?"
  :tail-matcher  "\%\>\"?"
  :pre-indent-offset #'poly-erb-pre-indent-offset
  :post-indent-offset #'poly-erb-post-indent-offset)

;;;###autoload  (autoload 'poly-coffee+erb-mode "poly-erb")
(define-polymode poly-coffee+erb-mode poly-coffee-root-polymode
  :innermodes '(poly-erb-innermode))

;;;###autoload
(define-polymode poly-js+erb-mode poly-js-root-polymode
  :innermodes '(poly-erb-innermode))

;;;###autoload  (autoload 'poly-html+erb-mode "poly-erb")
(define-polymode poly-html+erb-mode poly-html-root-polymode
  :innermodes '(poly-erb-innermode))

(add-to-list 'auto-mode-alist '("\\.js.erb\\'" . poly-js+erb-mode))
(add-to-list 'auto-mode-alist '("\\.coffee.erb\\'" . poly-coffee+erb-mode))
(add-to-list 'auto-mode-alist '("\\.html.erb\\'$" . poly-html+erb-mode))

(provide 'poly-erb)
