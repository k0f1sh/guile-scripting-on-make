#
# Print FEATURES
#
.PHONY: features
features:
	@echo $(.FEATURES)

#
# show guile version
#
define GUILE_SHOW_VERSION_CODE
(display "guile version: ")
(display (version))
(newline)
endef
.PHONY: show-guile-version
show-guile-version:
	@: $(guile $(GUILE_SHOW_VERSION_CODE))

#
# Hello, world!
#
.PHONY: hello
hello:
	@: $(guile (display "Hello, world!") (newline))

#
# Date
#
.PHONY: date
date:
	@: $(guile \
		(use-modules (srfi srfi-19)) \
		(display (date->string (current-date) "~a ~b ~e ~H:~I:~S ~z ~Y")) \
		(newline))

#
# grep
#
# example: $ echo -e "hello\nworld!" | PATTERN=he make grep-stdin
define GUILE_GREP_CODE
(use-modules (ice-9 textual-ports)) ;; only guile 3
(use-modules (srfi srfi-13))
(use-modules (srfi srfi-98))
(let ((pattern (get-environment-variable "PATTERN"))
      (port (current-input-port)))
  (if (not pattern)
      (begin (display "usage: PATTERN=<PATTERN> make grep-stdin") (newline))
      (let loop ((line (get-line port)))
        (if (not (eof-object? line))
            (begin
              (if (string-contains line pattern)
                  (begin
                    (display line)
                    (newline)))
              (loop (get-line port)))))))
endef

.PHONY: grep-stdin
grep-stdin:
	@: $(guile $(GUILE_GREP_CODE))
