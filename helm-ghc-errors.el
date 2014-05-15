;;; helm-ghc-errors.el --- Incremental search GHC errors/wanings by Helm
;;; -*- lexical-binding: t -*-

;; Copyright (C) 2014~         Syoudai Yokoyama

;; Author: Syoudai Yokoyama <thierry.volpiatto@gmail.com>
;; URL: http://github.com/emacs-helm/helm

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Code.

(require 'cl)
(require 'ghc)
(require 'helm)
(require 'shut-up)


(defstruct helm-ghc-error
  file
  row
  column
  message
  type)

(defun helm-ghc--errors/warnings-candidates ()
  (let* ((name (concat " ghc-modi:" ghc-process-process-name))
         (buf (get-buffer-create name)))
    (with-current-buffer buf
      (cl-loop for err in (ghc-read-lisp-this-buffer)
               for e = (split-string err ":")
               for msg = (mapconcat 'identity (nthcdr 3 e) ":")
               for typ = (if (string-match-p "^Warning" msg) 'warning 'err)
               collect (make-helm-ghc-error
                        :file (nth 0 e)
                        :row (string-to-number (nth 1 e))
                        :column (string-to-number (nth 2 e))
                        :message (with-temp-buffer
                                   (shut-up
                                     (insert msg)
                                     (goto-char (point-min))
                                     (replace-string "Warning: " "")
                                     (buffer-string)))
                        :type typ
                        ))
      )))

(provide 'helm-ghc-errors)
