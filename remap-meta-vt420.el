(defun remap-meta-vt420 (map)
  (map-keymap
   (lambda (_ev df)
     (if (keymapp df)
         (remap-meta-vt420 df)
       (unless (listp df)
         (let ((sub (substitute-command-keys (format "\\[%s]" df))))
           (when (and (string-match "^M\-" sub) (not (string-match "^M\-x" sub)))
             (global-set-key (kbd (concat "M-\\ " (replace-regexp-in-string "^M\-" "" sub))) df))
           (when (and (string-match "^C-M\-" sub) (not (string-match "^M\-x" sub)))
             (global-set-key (kbd (concat "M-\\ C-" (replace-regexp-in-string "^C-M\-" "" sub))) df))))))
   map))

(remap-meta-vt420 (current-global-map))
