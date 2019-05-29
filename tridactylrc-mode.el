;;; tridactylrc-mode.el --- A major mode for tridactyl's config file -*- lexical-binding: t -*-

;; Copyright (C) 2018 Alexander Miller

;; Author: Alexander Miller <alexanderm@web.de>
;; Package-Requires: ((emacs "24.3"))
;; Homepage: https://github.com/Alexander-Miller/treemacs
;; Version: 0.1

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

;;; Commentary:

;;; A major mode for tridactyl's config file.

;;; Code:

(defvar tridactylrc-font-lock-keywords
  ;; sanitise [items]
  `(( ,(rx
        bol
        (group-n 1 "sanitise")
        (zero-or-one
         (group-n 2 (1+ (seq " " (1+ alnum)))))
        eol)
      (1 font-lock-keyword-face)
      (2 font-lock-builtin-face))

    ;; colors
    ( ,(rx
        bol
        (group-n 1 (or "colors" "colours" "colorscheme" "colourscheme"))
        (0+ " ")
        (zero-or-one
         (group-n 2 (1+ (seq " " (1+ alnum)))))
        eol)
      (1 font-lock-keyword-face nil t)
      (2 font-lock-builtin-face nil t))

    ;; set key val
    ( ,(rx
        bol
        (group-n 1 "set" (? "pref"))
        (0+ " ")
        (zero-or-one
         (group-n 2 (1+ (or alnum "-" "_" ".")))
         (0+ " ")
         (zero-or-one
          (group-n 3 (1+ nonl))))
        eol)
      (1 font-lock-keyword-face nil t)
      (2 font-lock-variable-name-face nil t)
      (3 font-lock-constant-face nil t))

    ;; quickmark key val
    ( ,(rx
        bol
        (group-n 1 "quickmark" (?? " "))
        (zero-or-one
         (0+ " ")
         (group-n 2 (1+ (or "<" ">" "-" (syntax symbol) (syntax word) (syntax punctuation))) (? " "))
         (zero-or-one
          (0+ " ")
          (group-n 3 (1+ (or alnum num  "-"":" "." "/" "?" "=" "&"))))))
      (1 font-lock-keyword-face)
      (2 font-lock-type-face nil t)
      (3 font-lock-builtin-face nil t))

    ;; bind key val [number|modifier]
    ( ,(rx
        bol
        ;; (un)bind
        (group-n 1 (? "un") "bind" (?? " "))
        (zero-or-one
         (0+ " ")
         ;; <Key>
         (group-n 2 (1+ (or "<" ">" "-" (syntax symbol) (syntax word) (syntax punctuation))) (?? " "))
         (zero-or-one
          (0+ " ")
          ;; command1 command2
          (group-n
           3
           (seq
            (1+ (or letter "-" "_"))
            (0+
             (or
              ;; foo | bar
              (group-n 4 (seq (0+ " ") "|" (0+ " ")))
              (seq " " (not (any "-")) (1+ (or letter "-" "_"))))))
           (?? " "))
          (zero-or-one
           (0+ " ")
           (or (group-n
                5
                (? (or "+" "-")) (0+ num))
               (group-n
                6
                (or "#"
                    (1+ "-" (? "-") (1+ (or (syntax symbol) (syntax word) (syntax punctuation))))))))))
        eol)
      (1 font-lock-keyword-face)
      (2 font-lock-type-face nil t)
      (3 font-lock-function-name-face nil t)
      (4 font-lock-keyword-face t t)
      (5 font-lock-constant-face nil t)
      (6 font-lock-string-face nil t))

    ;; stupid workaround for comments
    ( ,(rx bol "\"" (1+ any) "\"" eol)
      0 font-lock-comment-face t)
    ))

;;;###autoload
(define-derived-mode tridactylrc-mode prog-mode "tridactylrc"
  (font-lock-add-keywords nil tridactylrc-font-lock-keywords)
  (setq-local comment-start "\"")
  (setq-local comment-end ""))

(provide 'tridactylrc-mode)

;;; tridactylrc-mode.el ends here
