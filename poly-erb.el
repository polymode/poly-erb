;;; poly-erb.el --- Polymode for erb -*- lexical-binding: t -*-
;;
;; Author: Siavash Sajjadi and Vitalie Spinu
;; Maintainer: Vitalie Spinu
;; Copyright (C) 2018
;; Version: 0.1.5
;; Package-Requires: ((emacs "25") (polymode "0.1.5"))
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

(defcustom pm-inner/erb
  (pm-inner-chunkmode :name "erb"
                      :mode 'ruby-mode
                      :head-matcher  "\"?\<\% *[-=]?"
                      :tail-matcher  "\%\>\"?"
                      :pre-indent-offset #'poly-erb-pre-indent-offset
                      :post-indent-offset #'poly-erb-post-indent-offset)
  "Erb typical chunk."
  :group 'poly-innermodes
  :type 'object)

;;;###autoload  (autoload 'poly-coffee+erb-mode "poly-erb")
(define-polymode poly-coffee+erb-mode
  :hostmode 'pm-host/coffee
  :innermodes '(pm-inner/erb))

;;;###autoload
(define-polymode poly-js+erb-mode
  :hostmode 'pm-host/js
  :innermodes '(pm-inner/erb))

;;;###autoload  (autoload 'poly-html+erb-mode "poly-erb")
(define-polymode poly-html+erb-mode
  :hostmode 'pm-host/html
  :innermodes '(pm-inner/erb))

(add-to-list 'auto-mode-alist '("\\.js.erb$" . poly-js+erb-mode))
(add-to-list 'auto-mode-alist '("\\.coffee.erb$" . poly-coffee+erb-mode))
(add-to-list 'auto-mode-alist '("\\.html.erb$" . poly-html+erb-mode))

(provide 'poly-erb)
