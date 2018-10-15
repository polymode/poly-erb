
(require 'ruby-mode)
(require 'poly-erb)
(require 'polymode-test-utils)


;; (ert-deftest poly-html+erb/spans-at-borders ()
;;   (pm-test-run-on-file poly-html+erb-mode "web-mode-test.html.erb"
;;     (pm-map-over-spans
;;      (lambda (span)
;;        (let* ((sbeg (nth 1 span))
;;               (send (nth 2 span))
;;               (range1 (pm-innermost-range sbeg))
;;               (range2 (pm-innermost-range send)))
;;          (should (eq sbeg (car range1)))
;;          (should (eq send (cdr range1)))
;;          (unless (eq send (point-max))
;;            (should (eq send (car range2)))))))))

;; (ert-deftest poly-html+erb/spans-at-narrowed-borders ()
;;   (pm-test-run-on-file poly-html+erb-mode "web-mode-test.html.erb"
;;     (pm-map-over-spans
;;      (lambda (span)
;;        (pm-with-narrowed-to-span span
;;          (let* ((range1 (pm-innermost-range (point-min)))
;;                 (range2 (pm-innermost-range (point-max))))
;;            (should (eq (car range1) (point-min)))
;;            (should (eq (cdr range1) (point-max)))
;;            (should (eq (car range2) (point-min)))
;;            (should (eq (cdr range2) (point-max)))))))))

;; (ert-deftest poly-html+erb/narrowed-spans ()
;;   (pm-test-run-on-file poly-html+erb-mode "web-mode-test.html.erb"
;;     (narrow-to-region 60 300)
;;     (let ((span (pm-innermost-span (point-min))))
;;       (should (eq (car span) 'head))
;;       (should (= (nth 1 span) 60))
;;       (should (= (nth 2 span) 66)))
;;     (let ((span (pm-innermost-span (point-max))))
;;       (should (eq (car span) 'body))
;;       (should (= (nth 1 span) 261))
;;       (should (= (nth 2 span) 300)))))

;; (ert-deftest poly-html+erb/spans-at-point-max ()
;;   (pm-test-run-on-file poly-html+erb-mode "web-mode-test.html.erb"
;;     (goto-char (point-max))
;;     (pm-switch-to-buffer)

;;     (let ((span (pm-innermost-span (point-max))))
;;       (should (eq (car span) 'nil))
;;       (should (eq (nth 2 span) (point-max)))
;;       (delete-region (nth 1 span) (nth 2 span)))

;;     (let ((span (pm-innermost-span (point-max))))
;;       (should (eq (car span) 'tail))
;;       (should (eq (nth 2 span) (point-max)))
;;       (delete-region (nth 1 span) (nth 2 span)))

;;     (let ((span (pm-innermost-span (point-max))))
;;       (should (eq (car span) 'body))
;;       (should (eq (nth 2 span) (point-max)))
;;       (delete-region (nth 1 span) (nth 2 span)))

;;     (let ((span (pm-innermost-span (point-max))))
;;       (should (eq (car span) 'head))
;;       (should (eq (nth 2 span) (point-max)))
;;       (delete-region (nth 1 span) (nth 2 span)))

;;     (let ((span (pm-innermost-span (point-max))))
;;       (should (eq (car span) 'nil))
;;       (should (eq (nth 2 span) (point-max)))
;;       (delete-region (nth 1 span) (nth 2 span)))))
