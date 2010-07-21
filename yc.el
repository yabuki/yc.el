;;; yc.el by knak 2008.02.13

;;; YC $B$O(B "Yet another Canna client" $B$NN,$G$9!#(B
;;; $BF,J8;z$r$H$k$H(B YACC $B$K$J$C$A$c$&$s$@$b$s(B (;_;)

;;;     $BG[I[>r7o(B: GPL
;;; $B:G?7HGG[I[85(B: http://www.ceres.dti.ne.jp/~knak/yc.html
;;; $B:n<T$NO"Mm@h(B: http://www.ceres.dti.ne.jp/~knak/yc.html $B$K5-:\(B

;;; YC$B$N4r$7$5(B:
;;;
;;; YC $B$O(B canna $BBP1~%Q%C%A$NEv$?$C$F$$$J$$(B
;;; emacs $B$r(B canna $BBP1~$K$9$k%W%m%0%i%`$G$9!#(B
;;; 
;;; YC $B$O(B ANK$B4A;zJQ49$r%5%]!<%H$7$^$9!#(B
;;; YC $B$O(B $B$+$J4A;zJQ49$r%5%]!<%H$7$^$9!#(B

;;; YC$B$N;H$$J}(B:
;;;
;;; YC$B$r%m!<%I8e!"(BC-\ (toggle-input-method) $B$G$+$J4A;zJQ49$G$-$^$9!#(B
;;; YC$B$r%m!<%I8e!"(B(yc-mode 1) $B$r<B9T$7$F$$$k$H(B
;;; C-\ $B$NF~NO$rK:$l$F!"(Bbuffer $B$K$$$-$J$j%m!<%^;z$rF~NO$7$F$b(B
;;; C-j $B$GJQ49$G$-$^$9!#(B
;;;
;;; YC$B$r%m!<%I8e!"(B(global-yc-mode 1) $B$r<B9T$9$k$H(B
;;; $BA4%P%C%U%!$G(BANK-$B4A;zJQ49$,$G$-$k$h$&$K$J$j$^$9(B
;;;
;;; global-yc-mode $B$H(B yc-mode $B$N0c$$(B:
;;;
;;; M-x yc-mode $B$O8=:_$N%P%C%U%!$KBP$7$F(B YC $B$N%H%0%k$r$9$k(B
;;; M-x global-yc-mode $B$OA4%P%C%U%!$KBP$7$F(B YC $B$N%H%0%k$r$9$k(B
;;; global-yc-mode $B$K$h$k%H%0%k$O8=:_$N(B buffer $B$KBP$7$F%H%0%k$7$?7k2L$r(B
;;; $BA4%P%C%U%!$KE,MQ$9$k(B
;;; $B$D$^$j!"8=:_$N%P%C%U%!$G(B YC $B$,%*%U>uBV$G$"$l$P(B
;;; global-yc-mode $B$N7k2L$O$=$NB>$N%P%C%U%!$N(B YC $B$N(B
;;; $B>uBV$K$+$+$o$i$:%*%s>uBV$K$J$k(B

;;; .emacs $B$NNc(B:
;;;
;;; (setq yc-server-host "CANNAHOST") ; cannaserver $B$r(B CANNAHOST $B$G5/F0$7$F$$$k(B
;;; (setq yc-rK-trans-key [henkan])   ; $BJQ49%-!<$r(B Henkan $B%-!<$K$9$k(B
;;; (setq yc-use-color t)             ; fence $B$r%+%i!<I=<($9$k(B
;;; (if (eq window-system 'x)
;;;    (setq yc-use-fence nil)        ; onX $B$J$i(B       || $B$rI=<($7$J$$(B
;;;  (setq yc-use-fence t))           ; onX $B$G$J$$$J$i(B || $B$rI=<($9$k(B
;;; (load "yc")                       ; yc $B$N%m!<%I(B
;;; (global-yc-mode 1)                ; $BA4%P%C%U%!$G(Bascii-$B4A;zJQ492DG=$K$9$k(B

;;; YC $B$N@_Dj(B:
;;;
;;;  $B!&(Byc-canna-lib-path $B$+$s$J$N%i%$%V%i%j!<%Q%9$r@_Dj$9$k(B(default.canna)
;;;  $B!&(Byc-canna-dic-path $B$+$s$J$N<-=q%Q%9$r@_Dj$9$k(B(default.{kp,cbp})
;;;  $B!&(Byc-icanna-path    icanna $B$X$N%Q%9$r@_Dj$9$k(B
;;;  $B!&(Byc-rH-conv-dic    $B$+$s$J$N%m!<%^;z(B-$B$R$i2>L>JQ49%F!<%V%k$r@_Dj$9$k(B
;;;  $B!&(Byc-select-count   $B0lMw%b!<%I$K$J$k7+$jJV$7?t$r@_Dj$9$k(B
;;;  $B!&(Byc-choice-stay    $BA*Br$KJ8@a$r?J$a$k$+N1$^$k$+$r@_Dj$9$k(B
;;;  $B!&(Byc-rK-trans-key   $B4A;zJQ49%-!<$r@_Dj$9$k(B
;;;  $B!&(Byc-stop-chars     ANK-$B4A;zJQ49;~$K<h$j9~$`J8;zNs$K(B
;;;                      $B4^$a$J$$J8;zNs$r@_Dj$9$k(B
;;;  $B!&(Byc-server-host    cannaserver $B$NF0$$$F$$$k%[%9%HL>$r@_Dj$9$k(B
;;;  $B!&(Byc-use-fence      fence$BI=<($N>~$jJ8;z(B(||)$B$rI=<($9$k(B
;;;  $B!&(Byc-use-color      fence$BI=<($r%+%i!<I=<($9$k(B

;;; YC TIPS:
;;;
;;;  $B!&$J$K$O$H$b$"$l(B C-j
;;;    $B4A;zJQ49$r$7$?$+$C$?$i(B C-j $B$3$l$@$1$O3P$($h$&(B
;;;    $B8e$O!"$*$J$8$_$N(B emacs $B$N%+!<%=%k0\F0%3%^%s%IBN7O$G2?$H$+$J$k(B
;;;    C-j $B$,7y$J$i(B yc $B%m!<%IA0$K(B yc-rK-trans-key $B$r@_Dj$9$k(B
;;;      (setq yc-rK-trans-key [henkan])
;;;
;;;  $B!&$R$i2>L>(B-$B4A;zJQ49$r$9$k$J$i(B C-\
;;;    $B$+$s$J$NI8=`$O(B C-o $B$@$1$I(B YC $B$O(B C-\ $B$G$R$i2>L>F~NOJT=8$K$J$k(B
;;;    (global-set-key "\C-o" 'toggle-input-method) $B$G(B C-o $B$K$G$-$k(B
;;;
;;;  $B!&(Balphabet $B$HJQ49$9$kJ8;zNs$N4V$K$O(B SPC $B$r$$$l$k(B
;;;    C-j $B$rF~NO$9$k$HH>3QJ8;zNs$,B3$/6h4V$rJQ49$7$h$&$H$9$k(B
;;;    alphabet $B$HJQ496h4V$O(B SPC $B$GJ,N%$9$k$H%9%`!<%:$KF~NO$,$G$-$k$h$&$K$J$k(B
;;;
;;;  $B!&(Balphabet $B$HJQ49$9$kJ8;zNs$N4V$K(B SPC $B$r$$$l$?$/$J$+$C$?$i(B C-@
;;;    YC $B$O(B region $B$,%+!<%=%k$N$"$k9T$KJD$8$F$$$k>l9g(B
;;;    region $B$rJQ49$7$h$&$H$9$k(B
;;;
;;;  $B!&%+%i%U%k$JJQ49$r$7$?$+$C$?$i(B yc-use-color $B$r(B t $B$K$9$k(B
;;;
;;;  $B!&4V0c$C$F3NDj$7$?$i:FJQ49(B
;;;    $B4V0c$C$F3NDj$7$F$b3NDjD>8e$J$i(B C-j $B$G:FJQ49$G$-$k(B
;;;    $B%+!<%=%k$rF0$+$7$?$j$9$k$H$b$&:FJQ49$G$-$J$$$1$I(B (T_T)
;;;
;;;  $B!&A43Q$R$i2>L>$dA43Q%"%k%U%!%Y%C%H$bJQ49$G$-$k(B
;;;
;;;  $B!&;z<oJQ49$b4A;zJQ498uJd$K4^$^$l$k(B

;;; K  ... $B4A;z(B
;;; r  ... romaji
;;; H  ... $B$R$i$,$J(B
;;; k  ... $B%+%?%+%J(B
;;; h  ... $BH>3Q%+%J(B
;;; a  ... alphabet
;;; A  ... $B#a#l#p#h#a#b#e#t(B

;;; rK ... romaji-$B4A;z(B
;;; rH ... romaji-$B$R$i$,$J(B
;;; Hk ... $B$R$i$,$J(B-$B%+%?%+%J(B
;;; Hh ... $B$R$i$,$J(B-$BH>3Q%+%J(B
;;; aA ... alphabet-$B#a#l#p#h#a#b#e#t(B
;;; Aa ... $B#a#l#p#h#a#b#e#t(B-alphabet

(defgroup yc nil
  "Yet another Canna client."
  :group 'input-method
  :group 'Japanese)

(defcustom yc-canna-lib-path
  (let ((dirs (append (let ((path (getenv "CANNALIBDIR")))
			(if (and path (not (string= path ""))) (list path)))
		      '("/usr/local/canna/lib/"
			"/usr/local/lib/canna/"
			"/usr/pkg/share/canna/"
			"/usr/lib/canna/"
			"/var/lib/canna/"))))
    (while (and dirs
		(not (file-regular-p (concat (car dirs) "/default.canna"))))
      (setq dirs (cdr dirs)))
    (car dirs))
  "*$B$+$s$J$N%i%$%V%i%j!<%Q%9(B(default.canna $B$N$"$k>l=j(B)$B$r@_Dj$9$k(B"
  :type 'directory
  :group 'yc)
(defsubst get-yc-canna-lib-path ()
  (condition-case nil
      (file-name-as-directory yc-canna-lib-path)
    (error "")))
(defcustom yc-canna-dic-path
  (concat (get-yc-canna-lib-path) "dic/")
  "*$B$+$s$J$N<-=q%Q%9(B(default.{cpb,kp}$B$N$"$k>l=j(B)$B$r@_Dj$9$k(B"
  :type 'directory
  :group 'yc)
(defcustom yc-icanna-path
  "icanna"
  "*canna$B$H(BUNIX domain socket$B7PM3$GDL?.$9$k$?$a$NJd=u%W%m%0%i%`(B(icanna)$B$N%Q%9$r@_Dj$9$k(B"
  :type 'file
  :group 'yc)
(defvar yc-rH-conv-dic 
  (let ((files '("default.cbp" "default.kp")))
    (while (and (car files)
		(not (file-readable-p 
		      (concat (file-name-as-directory yc-canna-dic-path)
			      (car files)))))
      (setq files (cdr files)))
    (when (car files) (concat yc-canna-dic-path (car files))))
  "$B$+$s$J$N%m!<%^;z$R$i2>L>JQ49%F!<%V%k%U%!%$%kL>$rJQ49$9$k(B")

(defcustom yc-select-count 2
  "*$B0lMw%b!<%I$K$J$k7+JV$7?t$r@_Dj$9$k!#%G%U%)%k%H$O(B3$B2s!#(B
$B$?$@$7(B ~/.canna $B$,$"$C$?>l9g$K$O!"Ev3:%U%!%$%k$+$i@_DjCM$rFI$_9~$`(B"
  :type 'integer
  :group 'yc)
(defcustom yc-choice-stay nil
  "*$B0lMw%b!<%I$GJQ498uJd$rA*Br$7$?$H$-$K<!$NJ8@a$K?J$`$+!"(B
$B8uJd$rA*Br$7$?J8@a$KN1$^$k$+$r;XDj$9$k!#(B
$B;XDj$,(B nil $B$N>l9g!"J8@a$r?J$a$k(B
$B;XDj$,(B $BHs(Bnil $B$N>l9g!"J8@a$KN1$^$k(B"
  :type 'boolean
  :group 'yc)
(defvar yc-rK-trans-key "\C-j"
  "*$B4A;zJQ49%-!<$r@_Dj$9$k(B")
(defcustom yc-stop-chars "(){}<>"
  "*$B4A;zJQ49J8;zNs$r<h$j9~$`;~$KJQ49HO0O$K4^$a$J$$J8;z$r@_Dj$9$k(B"
  :type 'string
  :group 'yc)
(defcustom yc-server-host nil
  "*cannaserver $B$,F0$$$F$$$k%[%9%HL>$r;XDj$9$k!#(B
nil $B$N>l9g!"(Blocalhost $B$r;XDj$7$?;v$K$J$k(B"
  :type 'string
  :group 'yc)
(defcustom yc-enable-hankaku t
  "*$BH>3Q$+$J$r;z<oJQ498uJd$H$7$FM-8z$K$9$k!#(B
$BHs(Bnil$B$N>l9g!"H>3Q$+$JM-8z!#(Bnil$B$N>l9g!"H>3Q$+$JL58z(B"
  :type 'boolean
  :group 'yc)
(defcustom yc-connect-server-at-startup t
  "*yc$B$rFI$_9~$s$@$i$9$0$K%5!<%P$K@\B3$9$k!#(B
$BHs(Bnil$B$N>l9g!"$9$0@\B3$9$k!#(Bnil$B$N>l9g!":G=i$K4A;zJQ49%-!<$r2!$9$^$G@\B3$7$J$$!#(B"
  :type 'boolean
  :group 'yc)

;; minibuffer $B%-!<%P%$%s%I(B
(and (boundp 'minibuffer-local-map) minibuffer-local-map
     (define-key minibuffer-local-map yc-rK-trans-key 'yc-rK-trans))

(defvar yc-mode nil         "$B4A;zJQ49%H%0%kJQ?t(B")
(defvar yc-henkan-mode nil  "$B4A;zJQ49%b!<%IJQ?t(B")
(defvar yc-input-mode nil   "$B$+$JF~NO%b!<%IJQ?t(B")
(defvar yc-edit-mode nil    "$B$+$JJT=8%b!<%IJQ?t(B")
(defvar yc-select-mode nil  "$B8uJd0lMw%b!<%IJQ?t(B")
(defvar yc-defword-mode nil "$BC18lEPO?%b!<%IJQ?t(B")
(defvar yc-wclist-mode nil  "$B4A;zA*Br%b!<%IJQ?t(B")
(or (assq 'yc-mode minor-mode-alist)
    (setq minor-mode-alist (cons '(yc-mode " yc") minor-mode-alist)))

(defvar yc-mode-map (make-sparse-keymap)         "$B4A;zJQ49%H%0%k%^%C%W(B")
(defvar yc-henkan-mode-map (make-sparse-keymap)  "$B4A;zJQ49%b!<%I%^%C%W(B")
(defvar yc-input-mode-map (make-sparse-keymap)   "$B$+$JF~NO%b!<%I%^%C%W(B")
(defvar yc-edit-mode-map (make-sparse-keymap)    "$B$+$JJT=8%b!<%I%^%C%W(B")
(defvar yc-select-mode-map (make-sparse-keymap)  "$B8uJd0lMw%b!<%I%^%C%W(B")
(defvar yc-defword-mode-map (make-sparse-keymap) "$BC18lEPO?%b!<%I%^%C%W(B")
(defvar yc-wclist-mode-map (make-sparse-keymap)  "$B4A;zA*Br%b!<%I%^%C%W(B")
(or (assq 'yc-mode minor-mode-map-alist)
    (setq minor-mode-map-alist
	  (append (list (cons 'yc-wclist-mode  yc-wclist-mode-map)
			(cons 'yc-defword-mode yc-defword-mode-map)
			(cons 'yc-select-mode  yc-select-mode-map)
			(cons 'yc-edit-mode    yc-edit-mode-map)
			(cons 'yc-input-mode   yc-input-mode-map)
			(cons 'yc-henkan-mode  yc-henkan-mode-map)
			(cons 'yc-mode         yc-mode-map))
		  minor-mode-map-alist)))
(if (boundp 'mode-line-mode-menu)
    (define-key mode-line-mode-menu [yc-mode]
      `(menu-item ,(purecopy "yc") yc-mode
		  :button (:toggle . yc-mode))))
(defvar yc-defword-minibuffer-map (copy-keymap minibuffer-local-map))
(set-keymap-parent yc-defword-minibuffer-map yc-input-mode-map)

;;;
;;; isearch $B;~$K(B boil $B=PMh$k$h$&$K$9$k(B
;;;
(defvar yc-isearch nil)
(defun yc-isearch-rK-trans (arg)
  "$B%$%s%/%j%a%s%?%k%5!<%ACf$K(BANK-$B4A;zJQ49$9$k4X?t(B"
  (interactive "p")
  (setq unread-command-events (list last-command-event))
  (let ((yc-isearch-string isearch-string))
    (while (not (string= isearch-string ""))
      (isearch-delete-char))
    (setq isearch-string yc-isearch-string))
  (setq yc-isearch t)
  (isearch-edit-string))

(defun yc-isearch-mode-function ()
  (define-key isearch-mode-map "\C-\\" 'yc-isearch-rK-trans)
  (define-key isearch-mode-map yc-rK-trans-key 'yc-isearch-rK-trans))

(add-hook 'isearch-mode-hook 'yc-isearch-mode-function)


;;;
;;; constants
;;;

;;;
;;; variable
;;;

(defvar yc-debug nil) ;" *canna*"

(defvar yc-server nil)
(defvar yc-prev-command nil)
(defvar yc-context nil)
(defvar yc-yomi-dic nil)
(defvar yc-rH-table nil)
(defvar yc-res-buffer nil)
(defvar yc-dic-list '("iroha" "fuzokugo" "hojomwd" "hojoswd" "keishiki"))
(defvar yc-user-dic-list '("user"))
(defvar yc-bushu-dic-list '("bushu"))
(defvar yc-current-frame nil)

(defvar yc-defsymbol-list nil)

;;;
;;; common function
;;;
(require 'timer)

(eval-when-compile ; appended by yagi@is.titech.ac.jp 2000.05.17
  (let ((funs '(char-category string-bytes frame-parameter)))
    (while funs
      (or (fboundp (car funs))
	  (fset (car funs) 'ignore))
      (setq funs (cdr funs)))))
(eval-and-compile
  (when (not (boundp 'auto-coding-alist))
    (defvar auto-coding-alist nil)))
(eval-and-compile
  (when (not (fboundp 'event-to-character))
    (defalias 'event-to-character (symbol-function '+))))
(eval-and-compile
  (if (fboundp 'encode-coding-char)
      (defalias 'yc-encode-coding-char (symbol-function 'encode-coding-char))
    (defun yc-encode-coding-char (ch coding)
      (encode-coding-string (char-to-string ch) coding))))

(eval-and-compile
  (if (= (length (substring "$B$"(B" 1)) 0)
      ;; $BJ8;zC10L$G(B substring $B$7$F$k(B
      (progn
	(defun yc-substring (str from &optional to)
	  (if (null (stringp str)) nil
	    (if (= (length str) 0) ""
	      (if (numberp to)
		  (substring str from to)
		(substring str from)))))
	;(defalias 'yc-substring (symbol-function 'substring))
	(defalias 'yc-strlen (symbol-function 'length)) )
    ;; byte $BC10L$G(B substring $B$7$F$k(B
    (defun yc-substring (str b &optional e)
      (let ((l (string-to-list str)))
	(concat (if e
		    (yc-subsequence l b e)
		  (nthcdr b l)))))
    (defun yc-strlen (str)
      (length (string-to-list str)))
    (defalias 'string-bytes (symbol-function 'length)) ))

;; $B%+!<%=%kA0$NJ8;z<o$rJV5Q$9$k4X?t(B
(eval-and-compile
  (if (>= emacs-major-version 20)
      (progn
	(defalias 'yc-char-charset (symbol-function 'char-charset))
	(when (and (boundp 'byte-compile-depth)
		   (not (fboundp 'char-category)))
	  (defalias 'char-category nil))) ; for byte compiler
    (defun yc-char-charset (ch)
      (cond ((equal (char-category ch) "a") 'ascii)
	    ((equal (char-category ch) "k") 'katakana-jisx0201)
	    ((string-match "[SAHK]j" (char-category ch)) 'japanese-jisx0208)
	    (t nil) )) ))

(eval-and-compile
  (if (fboundp 'redirect-frame-focus)
      (defalias 'yc-redirect-frame-focus
	(symbol-function 'redirect-frame-focus))
    (defun yc-redirect-frame-focus (base redirection)
      (if (null redirection)
	  (progn
	    (raise-frame (select-frame yc-current-frame))
	    (setq yc-current-frame nil))
	(setq yc-current-frame (selected-frame))
	(raise-frame (select-frame (window-frame (minibuffer-window))))))))

(defun yc-debug (obj)
  "yc-debug $BJQ?t$G;XDj$5$l$?%P%C%U%!$K(B OBJ $B$rI=<($9$k!#(B
OBJ $B$rJV5Q$9$k!#(B"
  (when (and yc-debug (processp yc-server))
    (let ((old (current-buffer)))
      (unwind-protect
	  (let (moving)
	    (set-buffer (process-buffer yc-server))
	    (setq moving (= (point) (process-mark yc-server)))
	    (save-excursion
	      (goto-char (process-mark yc-server))
	      (prin1 obj (process-buffer yc-server))
	      (terpri (process-buffer yc-server))
	      (set-marker (process-mark yc-server) (point)))
	    (when moving (goto-char (process-mark yc-server))))
	(set-buffer old))))
  obj)

;;;
;;; socket operation
;;;

(put 'yc-trap-server-down 'error-conditions '(error yc-trap-server-down))
(put 'yc-trap-server-down 'error-message "YC: disconnected cannaserver")

(defun yc-signal-server-down (&rest arg)
  "cannaserver $B$H$NDL?.>uBV$,JQ2=$7$?$H$-$KF0:n$9$k4X?t(B"
  (when (and (processp yc-server) (eq (process-status yc-server) 'closed))
    (set-process-sentinel yc-server nil))
  (if (waiting-for-user-input-p)
      (put 'yc-server 'init nil)
    (signal 'yc-trap-server-down (list yc-server-host))))

(defun yc-server-open ()
  "cannaserver $B$H$NDL?.$r3+;O$9$k4X?t(B"
  (let ((server (or yc-server-host (getenv "CANNAHOST"))))
    (setq yc-server-host (if (or (not server) (string= server ""))
			     "unix"
			   server))
    (setq yc-server
	  (cond ((string= yc-server-host "unix")
		 (if (featurep 'make-network-process)
		     (make-network-process
		      :name "canna"
		      :buffer yc-debug
		      :remote "/tmp/.iroha_unix/IROHA")
		   (let ((process-connection-type nil))
		     (start-process "canna" yc-debug yc-icanna-path))))
		(t (with-timeout (1 nil)
		     (condition-case nil
			 (open-network-stream
			  "canna" yc-debug yc-server-host 5680)
		       (error nil)))))))
  (when (processp yc-server)
    (put 'yc-server 'init nil)
    (process-kill-without-query yc-server)
    (when yc-debug
      (unwind-protect
	  (progn
	    (set-buffer (process-buffer yc-server))
	    (set-marker (process-mark yc-server) (point)))))
    (set-process-coding-system yc-server 'no-conversion 'no-conversion)
    (set-process-filter yc-server 'yc-filter)
    (set-process-sentinel yc-server 'yc-signal-server-down)))

;; (defun yc-server-close ()
;;   "cannaserver $B$H$NDL?.$r=*N;$9$k4X?t(B"
;;   (set-process-sentinel yc-server nil)
;;   (when (processp yc-server) (delete-process yc-server)))

;; modified 01/12/29 by matz@ruby-lang.org
(defun yc-server-close ()
  "cannaserver $B$H$NDL?.$r=*N;$9$k4X?t(B"
  (when (processp yc-server)
    (set-process-sentinel yc-server nil)
    (when (processp yc-server) (delete-process yc-server))))

(defun yc-server-check ()
  "cannaserver $B$HDL?.$G$-$k$+$r3NG'$9$k4X?t(B"
  (or (and (processp yc-server)
	   (or (eq (process-status yc-server) 'open)
	       (eq (process-status yc-server) 'run)))
      (save-excursion
	(prog2
	    (yc-server-open)
	    (and (processp yc-server)
		 (or (eq (process-status yc-server) 'open)
		     (eq (process-status yc-server) 'run)))))))


;;;
;;; structure convert utilities
;;;
(defconst yc-coding (if (featurep 'xemacs) 'euc-jp 'japanese-iso-8bit))

(defconst yc-code
  (list
   (list 'initialize                         1     "lla"      "ss")
   (list 'finalize                     (ash  2 8)  "ss"       "ssc")
   (list 'create-context               (ash  3 8)  "ss"       "sss")
   (list 'duplicate-context            (ash  4 8)  "sss"      "sss")
;   (list 'close-context                (ash  5 8)  "sss"      "ssc")
;   (list 'get-dictionary-list          (ash  6 8)  "ssss"     "sssA")
;   (list 'get-directory-list           (ash  7 8)  "ssss"     "sssA")
   (list 'mount-dictionary             (ash  8 8)  "sslsa"    "ssc")
;   (list 'unmount-dictionary           (ash  9 8)  "sslsa"    "ssc")
;   (list 'remount-dictionary           (ash 10 8)  "sslsa"    "ssc")
;   (list 'mount-dictionary-list        (ash 11 8)  "ssss"     "sssA")
;   (list 'query-dictionary             (ash 12 8)  "sslsaa"   "sscaaL") ; v2.0
   (list 'define-word                  (ash 13 8)  "ssswa"    "ssc")
;   (list 'delete-word                  (ash 14 8)  "ssswa"    "ssc")
   (list 'begin-convert                (ash 15 8)  "sslsw"    "sssW")
   (list 'end-convert                  (ash 16 8)  "sssslS"   "ssc")
   (list 'get-candidacy-list           (ash 17 8)  "sssss"    "sssW")
   (list 'get-yomi                     (ash 18 8)  "sssss"    "sssw")
;   (list 'subst-yomi                   (ash 19 8)  "ssssssw"  "sssW") ; v2.0
;   (list 'store-yomi                   (ash 20 8)  "ssssw"    "sssW")
;   (list 'store-range                  (ash 21 8)  "ssssw"    "sscw") ; v2.0
;   (list 'get-last-yomi                (ash 22 8)  "ssss"     "sssw") ; v2.0
;   (list 'flush-yomi                   (ash 23 8)  "sssslS"   "sssW") ; v2.0
;   (list 'remove-yomi                  (ash 24 8)  "sssslS"   "ssc") ; v2.0
;   (list 'get-simple-kanji             (ash 25 8)  "sssawsss" "sssWW") ; v2.0
   (list 'resize-pause                 (ash 26 8)  "sssss"    "sssW")
;   (list 'get-hinshi                   (ash 27 8)  "ssssss"   "sscw") ; v2.0
;   (list 'get-lex                      (ash 28 8)  "ssssss"   "sssL")
;   (list 'get-status                   (ash 29 8)  "sssss"    "sscL")
;   (list 'set-locale                   (ash 30 8)  "sslsa"    "ssc") ; v2.0
;   (list 'auto-convert                 (ash 31 8)  "ssssl"    "ssc")
;   (list 'query-extensions             (ash 32 8)  "ssA"      "ssc")
   (list 'set-application-name         (ash 33 8)  "sslsa"    "ssc") ; v3.0
   (list 'notice-group-name            (ash 34 8)  "sslsa"    "ssc")
;   (list 'kill-server                  (ash 36 8)  "ss"       "ssc") ; v3.3
;   (list 'get-server-info          (1+ (ash  1 8)) "ss"       "ssc") ;
;   (list 'get-access-control-list  (1+ (ash  2 8)) "ss"       "sssA")
   (list 'create-dictionary        (1+ (ash  3 8)) "sslsa"    "ssc")
;   (list 'delete-dictionary        (1+ (ash  4 8)) "sslsa"    "ssc")
;   (list 'rename-dictionary        (1+ (ash  5 8)) "sslsaa"   "ssc")
;   (list 'get-word-text-dictionary (1+ (ash  6 8)) "sssaas"   "sssw")
;   (list 'list-dictionary          (1+ (ash  7 8)) "sssas"    "sscA")
;   (list 'sync                     (1+ (ash  8 8)) "sslsa"    "ssc") ; v3.2
;   (list 'chmod-dictionary         (1+ (ash  9 8)) "sslsa"    "sss") ; v3.2
;   (list 'copy-dictionary          (1+ (ash 10 8)) "sslsaaa"  "ssc") ; v3.2
   ))
(defconst yc-rcode
  (mapcar (lambda (lst) (cons (cadr lst) (car lst))) yc-code))
(defun yc-cmd-symbol (cmd)
  (cond ((symbolp cmd) cmd)
	((integerp cmd) (cdr (assq cmd yc-rcode)))
	(t nil)))
(defun yc-cmd-code (cmd)
  (cond ((symbolp cmd) (nth 1 (assq cmd yc-code)))
	((integerp cmd) cmd)
	(t nil)))
(defun yc-req-form (cmd)
  (cond ((symbolp cmd) (nth 2 (assq cmd yc-code)))
	((integerp cmd) (nth 2 (assoc (yc-cmd-symbol cmd) yc-code)))
	(t nil)))
(defun yc-res-form (cmd)
  (cond ((symbolp cmd) (nth 3 (assq cmd yc-code)))
	((integerp cmd) (nth 3 (assoc (yc-cmd-symbol cmd) yc-code)))
	(t nil)))

;;;
;;; mode of canna
;;;
;; real mode
; (defconst yc-mode-alpha               0)
; (defconst yc-mode-empty               1)
; (defconst yc-mode-kigo                2)
; (defconst yc-mode-yomi                3)
; (defconst yc-mode-jishu               4)
; (defconst yc-mode-tankouho            5)
; (defconst yc-mode-ichiran             6)
; (defconst yc-mode-yesno               7)
; (defconst yc-mode-onoff               8)
; (defconst yc-mode-adjust-bunsetsu     9)
; (defconst yc-mode-chikuji-yomi       10)
; (defconst yc-mode-chikuji-tan        11)
; (defconst yc-mode-max-real-mode      (1+ yc-mode-chikuji-tan))
;; imaginary mode
; (defconst yc-mode-henkan             yc-mode-empty)
; (defconst yc-mode-henkan-nyuryoku    12)
(defconst yc-mode-zen-hira-henkan    13)
; (defconst yc-mode-han-hira-henkan    14)
; (defconst yc-mode-zen-kata-henkan    15)
; (defconst yc-mode-han-kata-henkan    16)
; (defconst yc-mode-zen-alpha-henkan   17)
; (defconst yc-mode-han-alpha-henkan   18)
; (defconst yc-mode-zen-hira-kakutei   19)
; (defconst yc-mode-han-hira-kakutei   20)
; (defconst yc-mode-zen-kata-kakutei   21)
; (defconst yc-mode-han-kata-kakutei   22)
; (defconst yc-mode-zen-alpha-kakutei  23)
; (defconst yc-mode-han-alpha-kakutei  24)
; (defconst yc-mode-hex                25)
; (defconst yc-mode-bushu              26)
; (defconst yc-mode-extend             27)
; (defconst yc-mode-russian            28)
; (defconst yc-mode-greek              29)
; (defconst yc-mode-line               30)
; (defconst yc-mode-changing-server    31)
; (defconst yc-mode-henkan-method      32)
; (defconst yc-mode-delete-dic         33)
; (defconst yc-mode-touroku            34)
; (defconst yc-mode-touroku-empty      yc-mode-touroku)
; (defconst yc-mode-touroku-hinshi     35)
; (defconst yc-mode-touroku-dic        36)
; (defconst yc-mode-quoted-insert      37)
; (defconst yc-mode-bubun-muhenkan     38)
; (defconst yc-mode-mount-dic          39)
; (defconst yc-mode-max-imaginary-mode (1+ yc-mode-mount-dic))
;; dictionary mode
 (defconst yc-mode-mount-dic         512)


(defun yc-l2n (int)
  (concat (list (logand (ash int -24) 255)
		(logand (ash int -16) 255)
		(logand (ash int  -8) 255)
		(logand      int      255))))
(defun yc-s2n (int)
  (concat (list (logand (ash int -8) 255)
		(logand      int     255))))
(defun yc-c2n (int)
  (concat (list (logand int 255))))
(defun yc-a2n (str)
  (concat str (yc-c2n 0)))
(defun yc-w2n (str)
  (apply 'concat
	 (append (mapcar (lambda (str) 
			   (if (= 1 (length str)) (concat (yc-c2n 0) str) str))
			 (mapcar (lambda (ch)
				   (yc-encode-coding-char ch yc-coding))
				 (append str nil)))
		 (list (yc-s2n 0)))))

;(defun yc-n2l (str)
;  (logior (if (/= (logand (aref str 0) 128) 0) (ash -1 32) 0)
;          (ash (aref str 0) 24)
;          (ash (aref str 1) 16)
;          (ash (aref str 2)  8)
;          (aref str 3)))
(defun yc-n2s (str)
  (logior (if (/= (logand (aref str 0) 128) 0) (ash -1 16) 0)
          (ash (aref str 0) 8)
          (aref str 1)))
(defun yc-n2c (str)
  (logior (if (/= (logand (aref str 0) 128) 0) (ash -1 8) 0)
          (aref str 0)))
;(defun yc-n2a (str)
;  (substring str 0 (string-match (yc-c2n 0) str)))
(defun yc-n2w (str)
  (let ((src
	 (append (substring str 0 (string-match (yc-s2n 0) str)) nil))
	(dst))
    (while src
      (setq dst (concat
		 dst
		 (decode-coding-string 
		  (concat (and (/= (car src) 0) (char-to-string (car src)))
			  (char-to-string (cadr src)))
		  yc-coding))
	    src (cddr src)))
    dst))

;;;
;;; packet format
;;;
;; l ... word
;; s ... half
;; c ... byte
;; a ... single-byte-string
;; w ... multi-byte-string
;; L ... list of word
;; S ... list of half
;; A ... list of single-byte-string  ex) string^@string^@string^@^@
;; W ... list of multi-byte-string   ex) string^@^@string^@^@string^@^@^@^@

(defvar yc-res nil)
(defvar yc-args nil)
(defvar yc-form nil)
(defvar yc-str nil)

(defun yc-pack-l2n () (setq yc-res (concat yc-res (yc-l2n (car yc-args)))))
(defun yc-pack-s2n () (setq yc-res (concat yc-res (yc-s2n (car yc-args)))))
;(defun yc-pack-c2n () (setq yc-res (concat yc-res (yc-c2n (car yc-args)))))
(defun yc-pack-a2n () (setq yc-res (concat yc-res (yc-a2n (car yc-args)))))
(defun yc-pack-w2n () (setq yc-res (concat yc-res (yc-w2n (car yc-args)))))
;(defun yc-pack-L2n () (let* ((yc-args (car yc-args))
;			     (yc-form (make-string (length yc-args) ?l)))
;			(yc-pack-sub)))
(defun yc-pack-S2n () (let* ((yc-args (car yc-args))
 			     (yc-form (make-string (length yc-args) ?s)))
 			(yc-pack-sub)))
;(defun yc-pack-A2n () (let* ((yc-args (car yc-args))
;			     (yc-form (make-string (length yc-args) ?a)))
;			(yc-pack-sub)
;			(setq yc-res (concat yc-res (yc-c2n 0)))))
;(defun yc-pack-W2n () (let* ((yc-args (car yc-args))
;			     (yc-form (make-string (length yc-args) ?w)))
;			(yc-pack-sub)
;			(setq yc-res (concat yc-res (yc-s2n 0)))))

(defun yc-pack-sub ()
  (while (/= (length yc-form) 0)
    (cond ((= (string-to-char yc-form) ?l) (yc-pack-l2n))
	  ((= (string-to-char yc-form) ?s) (yc-pack-s2n))
;	  ((= (string-to-char yc-form) ?c) (yc-pack-c2n))
	  ((= (string-to-char yc-form) ?a) (yc-pack-a2n))
	  ((= (string-to-char yc-form) ?w) (yc-pack-w2n))
;	  ((= (string-to-char yc-form) ?L) (yc-pack-L2n))
	  ((= (string-to-char yc-form) ?S) (yc-pack-S2n))
;	  ((= (string-to-char yc-form) ?A) (yc-pack-A2n))
;	  ((= (string-to-char yc-form) ?W) (yc-pack-W2n))
	  )
    (setq yc-form (substring yc-form 1)
	  yc-args (cdr yc-args))))
	 
(defun yc-pack (yc-form yc-args)
  (or (stringp yc-form)
      (error "yc-pack: form doesn't string"))
  (let (yc-res)
    (yc-pack-sub)
    yc-res))

;(defun yc-unpack-n2l ()
;  (setq yc-res (append yc-res (list (yc-n2l (substring yc-str 0 4))))
;	yc-str (substring yc-str 4)))
(defun yc-unpack-n2s ()
  (setq yc-res (append yc-res (list (yc-n2s (substring yc-str 0 2))))
 	yc-str (substring yc-str 2)))
(defun yc-unpack-n2c ()
  (setq yc-res (append yc-res (list (yc-n2c (substring yc-str 0 1))))
 	yc-str (substring yc-str 1)))
;(defun yc-unpack-n2a ()
;  (let ((idx (+ (string-match (yc-c2n 0) yc-str) 2)))
;    (setq yc-res (append yc-res (list (yc-n2a (substring yc-str 0 idx))))
;	  yc-str (substring yc-str idx))))
(defun yc-unpack-n2w ()
  (let ((idx (+ (string-match (yc-s2n 0) yc-str) 2)))
    (setq yc-res (append yc-res (list (yc-n2w (substring yc-str 0 idx))))
 	  yc-str (substring yc-str idx))))
;(defun yc-unpack-n2L ()
;  (let ((yc-form (make-string (/ (length yc-str) 4) ?l)))
;    (yc-unpack-sub)))
;(defun yc-unpack-n2S ()
;  (let ((yc-form (make-string (/ (length yc-str) 2) ?s)))
;    (yc-unpack-sub)))
;(defun yc-unpack-n2A ()
;  (let ((idx (string-match (yc-s2n 0) yc-str)))
;    (setq yc-res (append yc-res
;			 (list (split-string 0 (substring yc-str 0 idx))))
;	  yc-str (substring yc-str (+ idx 2)))))
(defun yc-unpack-n2W ()
  (let (src dst)
    (while (/= 0 (or (setq src (string-match (yc-s2n 0) yc-str)) 0))
      (setq dst (append dst (list (yc-n2w (substring yc-str 0 (+ src 2)))))
 	    yc-str (substring yc-str (+ src 2))))
    (when (= src 0) (setq yc-str (substring yc-str src)))
    (setq yc-res (append yc-res (list dst)))))

(defun yc-unpack-sub ()
  (while (/= (length yc-form) 0)
    (cond ;((= (string-to-char yc-form) ?l) (yc-unpack-n2l))
	  ((= (string-to-char yc-form) ?s) (yc-unpack-n2s))
	  ((= (string-to-char yc-form) ?c) (yc-unpack-n2c))
;	  ((= (string-to-char yc-form) ?a) (yc-unpack-n2a))
	  ((= (string-to-char yc-form) ?w) (yc-unpack-n2w))
;	  ((= (string-to-char yc-form) ?L) (yc-unpack-n2L))
;	  ((= (string-to-char yc-form) ?S) (yc-unpack-n2S))
;	  ((= (string-to-char yc-form) ?A) (yc-unpack-n2A))
	  ((= (string-to-char yc-form) ?W) (yc-unpack-n2W)))
    (setq yc-form (substring yc-form 1))))

(defun yc-unpack (yc-form yc-str)
  (or (stringp yc-form)
      (error "yc-unpack: form doesn't string"))
  (let (yc-res)
    (yc-unpack-sub)
    yc-res))


;;;
;;; send request packet & dispose response packet
;;;

;; cannaserver $B$KMW5a$rAw?.$71~Ez$rJV5Q$9$k4X?t(B
(defun yc-request-server (cmd &optional args)
  (if (not (and (yc-server-check) (yc-init-p)))
      (signal 'yc-trap-server-down (list yc-server-host))
    (setq yc-prev-command cmd)
    (let* ((form (yc-req-form cmd))
	   (body (yc-pack (substring form 2) args))
	   (packet (concat (yc-pack (substring form 0 2)
				    (list (yc-cmd-code cmd) (length body)))
			   body)))
      (yc-debug (concat "     >> " packet))
      (process-send-string yc-server packet)
      (yc-debug (yc-response-server)))))

;;;
;;; recieve response packet & dispatch
;;;

;; cannaserver $B$+$i1~Ez$rC_@Q$9$k4X?t(B
(defun yc-filter (process response)
  (yc-debug (concat "     << " response))
  (setq yc-res-buffer (concat yc-res-buffer response)))

;; cannaserver $B$+$i$N1~Ez$r2r@O$7$F%j%9%H$KJQ49$7$FLa$k4X?t(B
(defun yc-response-server ()
  (while (< (length yc-res-buffer) 4) (accept-process-output yc-server))
  (if (eq (yc-cmd-symbol yc-prev-command) 'initialize)
      (prog1
	  (cons t
		(yc-unpack (yc-res-form 'initialize) yc-res-buffer))
	(setq yc-res-buffer nil))
    (let* ((tmp (yc-unpack "ss" yc-res-buffer))
	   (cmd (car tmp))
	   (len (+ 4 (nth 1 tmp))))
      (while (< (length yc-res-buffer) len)
	(accept-process-output yc-server))
      (prog1
	  (cons (eq (yc-cmd-symbol cmd) (yc-cmd-symbol yc-prev-command))
		(yc-unpack (yc-res-form cmd) yc-res-buffer))
	(setq yc-res-buffer nil)))))

;; cannaserver $B$H(B CANNA $B%W%m%H%3%k$r$d$j<h$j$9$k4X?t72(B
(defun yc-initialize (major minor user-name)
  (yc-debug (list 'initialize major minor user-name))
  (let* ((key (format "%d.%d:%s" major minor user-name))
	 (res (yc-request-server 'initialize (list key)))
	 (context (nth 2 res)))
    (and (car res) (/= context -1) context)))

(defun yc-finalize ()
  (yc-debug (cons 'finalize nil))
  (let ((res (yc-request-server 'finalize nil)))
    (and (car res) (/= (nth 3 res) -1))))

(defun yc-create-context ()
  (yc-debug (cons 'create-context nil))
  (let ((res (yc-request-server 'create-context nil)))
    (and (car res) (/= (nth 3 res) -1) (nth 3 res))))

(defun yc-duplicate-context (context)
  (yc-debug (cons 'duplicate-context (list context)))
  (let ((res (yc-request-server 'duplicate-context (list context))))
    (and (car res) (/= (nth 3 res) -1) (nth 3 res))))

;(defun yc-close-context (context)
;  (yc-debug (cons 'close-context (list context)))
;  (let ((res (yc-request-server 'close-context (list context))))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-get-dictionary-list (context buffer-size)
;  (yc-debug (cons 'get-dictionary-list (list context buffer-size)))
;  (let ((res (yc-request-server 'get-dictionary-list
;				(list context buffer-size))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-get-directory-list (context buffer-size)
;  (yc-debug (cons 'get-directory-list (list context buffer-size)))
;  (let ((res (yc-request-server 'get-directory-list
;				(list context buffer-size))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

(defun yc-mount-dictionary (mode context dic-name)
  (yc-debug (cons 'mount-dictionary (list mode context dic-name)))
  (let ((res (yc-request-server 'mount-dictionary
				(list mode context dic-name))))
    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-unmount-dictionary (mode context dic-name)
;  (yc-debug (cons 'unmount-dictionary (list mode context dic-name)))
;  (let ((res (yc-request-server 'unmount-dictionary
;				(list mode context dic-name))))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-remount-dictionary (priority context dic-name)
;  (yc-debug (cons 'remount-dictionary (list priority context dic-name)))
;  (let ((res (yc-request-server 'remount-dictionary
;				(list priority context dic-name))))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-mount-dictionary-list (context buffer-size)
;  (yc-debug (cons 'mount-dictionary-list (list context buffer-size)))
;  (let ((res (yc-request-server 'mount-dictionary-list
;				(list context buffer-size))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-query-dictionary (mode context user-name dic-name)
;  (yc-debug (cons 'query-dictionary (list mode context user-name dic-name)))
;  (let ((res (yc-request-server 'query-dictionary
;				(list mode context user-name dic-name))))
;    (and (car res) (/= (nth 3 res) -1) (nthcdr 4 res))))

(defun yc-define-word (context word-info dic-name)
  (yc-debug (cons 'define-word (list context word-info dic-name)))
  (let ((res (yc-request-server 'define-word
				(list context word-info dic-name))))
    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-delete-word (context word-info dic-name)
;  (yc-debug (cons 'delete-word (list context word-info dic-name)))
;  (let ((res (yc-request-server 'delete-word
;				(list context word-info dic-name))))
;    (and (car res) (/= (nth 3 res) -1))))

(defun yc-begin-convert (mode context yomi)
  (yc-debug (cons 'begin-convert (list mode context yomi)))
  (let ((res (yc-request-server 'begin-convert (list mode context yomi))))
    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

(defun yc-end-convert (context node mode selections)
  (yc-debug (cons 'end-convert (list context node mode selections)))
  (let ((res (yc-request-server 'end-convert
				(list context node mode selections))))
    (and (car res) (/= (nth 3 res) -1))))

(defun yc-get-candidacy-list (context node buf-size)
  (yc-debug (cons 'get-candidacy-list (list context node buf-size)))
  (let ((res (yc-request-server 'get-candidacy-list
				(list context node buf-size))))
    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

(defun yc-get-yomi (context node buf-size)
  (yc-debug (cons 'get-yomi (list context node buf-size)))
  (let ((res (yc-request-server 'get-yomi (list context node buf-size))))
    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-subst-yomi (context start-offset finish-offset len yomi)
;  (yc-debug (cons 'subst-yomi
;		  (list context start-offset finish-offset len yomi)))
;  (let ((res (yc-request-server 'subst-yomi
;				(list context start-offset finish-offset
;				      len yomi))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-store-yomi (context node yomi)
;  (yc-debug (cons 'store-yomi (list context node yomi)))
;  (let ((res (yc-request-server 'store-yomi (list context node yomi))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-store-range (context node yomi)
;  (yc-debug (cons 'store-range (list context node yomi)))
;  (let ((res (yc-request-server 'store-range (list context node yomi))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-get-last-yomi (context buf-size)
;  (yc-debug (cons 'get-last-yomi (list context buf-size)))
;  (let ((res (yc-request-server 'get-last-yomi (list context buf-size))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-flush-yomi (context node mode selections)
;  (yc-debug (cons 'flush-yomi (list context node mode selections)))
;  (let ((res (yc-request-server 'flush-yomi
;				(list context node mode selections))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-remove-yomi (context node mode selections)
;  (yc-debug (cons 'remove-yomi (list context node mode selections)))
;  (let ((res (yc-request-server 'remove-yomi
;				(list context node mode selections))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-get-simple-kanji
;  (context dic-name yomi len kouho-buf-size hinsi-buf-size)
;  (yc-debug (cons 'get-simple-kanji
;		  (list context dic-name yomi len kouho-buf-size
;			hinsi-buf-size)))
;  (let ((res (yc-request-server 'get-simple-kanji
;				(list context dic-name yomi len kouho-buf-size
;				      hinsi-buf-size))))
;    (and (car res) (/= (nth 3 res) -1) (nthcdr 4 res))))

(defun yc-resize-pause (context node len)
  (yc-debug (cons 'resize-pause (list context node len)))
  (let ((res (yc-request-server 'resize-pause (list context node len))))
    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-get-hinshi (context node kouho buf-size)
;  (yc-debug (cons 'get-hinshi (list context node kouho buf-size)))
;  (let ((res (yc-request-server 'get-hinshi
;				(list context node kouho buf-size))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-get-lex (context node kouho buf-size)
;  (yc-debug (cons 'get-lex (list context node kouho buf-size)))
;  (let ((res (yc-request-server 'get-lex (list context node kouho buf-size))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-get-status (context node kouho)
;  (yc-debug (cons 'get-status (list context node kouho)))
;  (let ((res (yc-request-server 'get-status (list context node kouho))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-set-locale (mode context locale)
;  (yc-debug (cons 'set-locale (list mode context locale)))
;  (let ((res (yc-request-server 'set-locale (list mode context locale))))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-auto-convert (context buf-size mode)
;  (yc-debug (cons 'auto-convert (list context buf-size mode)))
;  (let ((res (yc-request-server 'auto-convert (list context buf-size mode))))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-query-extensions (&rest request-list)
;  (yc-debug (cons 'query-extensions (list request-list)))
;  (let ((res (yc-request-server 'query-extensions (list request-list))))
;    (and (car res) (/= (nth 3 res) -1))))

(defun yc-set-application-name (mode context application)
  (yc-debug (cons 'set-application-name (list mode context application)))
  (let ((res (yc-request-server 'set-application-name
				(list mode context application))))
    (and (car res) (/= (nth 3 res) -1))))

(defun yc-notice-group-name (mode context group)
  (yc-debug (cons 'notice-group-name (list mode context group)))
  (let ((res (yc-request-server 'notice-group-name (list mode context group))))
    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-kill-server ()
;  (yc-debug (cons 'kill-server nil))
;  (let ((res (yc-request-server 'kill-server nil)))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-get-server-info ()
;  (yc-debug (cons 'get-server-info nil))
;  (let ((res (yc-request-server 'get-server-info nil)))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-get-access-control-list ()
;  (yc-debug (cons 'get-access-control-list nil))
;  (let ((res (yc-request-server 'get-access-control-list nil)))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

(defun yc-create-dictionary (mode context dic-name)
  (yc-debug (cons 'create-dictionary (list mode context dic-name)))
  (let ((res (yc-request-server 'create-dictionary
				(list mode context dic-name))))
    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-delete-dictionary (mode context dic-name)
;  (yc-debug (cons 'delete-dictionary (list mode context dic-name)))
;  (let ((res (yc-request-server 'delete-dictionary
;				(list mode context dic-name))))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-rename-dictionary (mode context dic-name new-dic-name)
;  (yc-debug (cons 'rename-dictionary
;		  (list mode context dic-name new-dic-name)))
;  (let ((res (yc-request-server 'rename-dictionary
;				(list mode context dic-name new-dic-name))))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-get-word-text-dictionary (context dir dic-name buf-size)
;  (yc-debug (cons 'get-word-text-dictionary
;		  (list context dir dic-name buf-size)))
;  (let ((res (yc-request-server 'get-word-text-dictionary
;				(list context dir dic-name buf-size))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-list-dictionary (context &rest dir)
;  (yc-debug (cons 'list-dictionary (list context dir)))
;  (let ((res (yc-request-server 'list-dictionary (list context dir))))
;    (and (car res) (/= (nth 3 res) -1) (nth 4 res))))

;(defun yc-sync (mode context dic-name)
;  (yc-debug (cons 'sync (list mode context dic-name)))
;  (let ((res (yc-request-server 'sync (list mode context dic-name))))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-chmod-dictionary (mode context dic-name)
;  (yc-debug (cons 'chmod-dictionary (list mode context dic-name)))
;  (let ((res (yc-request-server 'chmod-dictionary
;				(list mode context dic-name))))
;    (and (car res) (/= (nth 3 res) -1))))

;(defun yc-copy-dictionary (mode context dir src dst)
;  (yc-debug (cons 'copy-dictionary (list mode context dir src dst)))
;  (let ((res (yc-request-server 'copy-dictionary
;				(list mode context dir src dst))))
;    (and (car res) (/= (nth 3 res) -1))))


;;;
;;; $B;z<oJQ49(B
;;;

;; default $B%m!<%^;z(B-$B$R$i2>L>JQ49%F!<%V%k(B
(defconst yc-default-rH-table
  '(("~" "$B!1(B" "") ("}" "$B!Y(B" "") ("|" "$B!C(B" "") ("{" "$B!X(B" "") ("zz" "$B$C(B" "z")
    ("zyu" "$B$8$e(B" "") ("zyo" "$B$8$g(B" "") ("zyi" "$B$8$#(B" "") ("zye" "$B$8$'(B" "")
    ("zya" "$B$8$c(B" "") ("zu" "$B$:(B" "") ("zo" "$B$>(B" "") ("zi" "$B$8(B" "")
    ("ze" "$B$<(B" "") ("za" "$B$6(B" "") ("yy" "$B$C(B" "y") ("yu" "$B$f(B" "") ("yo" "$B$h(B" "")
    ("yi" "$B$$(B" "") ("ye" "$B$$$'(B" "") ("ya" "$B$d(B" "") ("xyu" "$B$e(B" "")
    ("xyo" "$B$g(B" "") ("xya" "$B$c(B" "") ("xwa" "$B$n(B" "") ("xu" "$B$%(B" "")
    ("xtu" "$B$C(B" "") ("xtsu" "$B$C(B" "") ("xo" "$B$)(B" "") ("xi" "$B$#(B" "")
    ("xe" "$B$'(B" "") ("xa" "$B$!(B" "") ("'" "$B!G(B" "") ("\"" "$B!I(B" "") ("ww" "$B$C(B" "w")
    ("wu" "$B$&(B" "") ("wo" "$B$r(B" "") ("wi" "$B$p(B" "") ("we" "$B$q(B" "") ("wa" "$B$o(B" "")
    ("vv" "$B$C(B" "v") ("vu" "$B$&!+(B" "") ("vo" "$B$&!+$)(B" "") ("vi" "$B$&!+$#(B" "")
    ("ve" "$B$&!+$'(B" "") ("va" "$B$&!+$!(B" "") ("u" "$B$&(B" "") ("tyu" "$B$A$e(B" "")
    ("tyo" "$B$A$g(B" "") ("tyi" "$B$A$#(B" "") ("tye" "$B$A$'(B" "") ("tya" "$B$A$c(B" "")
    ("tu" "$B$D(B" "") ("tt" "$B$C(B" "t") ("tsu" "$B$D(B" "") ("tso" "$B$D$)(B" "")
    ("tsi" "$B$D$#(B" "") ("tse" "$B$D$'(B" "") ("tsa" "$B$D$!(B" "") ("to" "$B$H(B" "")
    ("ti" "$B$A(B" "") ("thu" "$B$F$e(B" "") ("tho" "$B$F$g(B" "") ("thi" "$B$F$#(B" "")
    ("the" "$B$F$'(B" "") ("tha" "$B$F$c(B" "") ("te" "$B$F(B" "") ("tch" "$B$C(B" "ch")
    ("ta" "$B$?(B" "") ("syu" "$B$7$e(B" "") ("syo" "$B$7$g(B" "") ("syi" "$B$7$#(B" "")
    ("sye" "$B$7$'(B" "") ("sya" "$B$7$c(B" "") ("su" "$B$9(B" "") ("ss" "$B$C(B" "s")
    ("so" "$B$=(B" "") ("si" "$B$7(B" "") ("shu" "$B$7$e(B" "") ("sho" "$B$7$g(B" "")
    ("shi" "$B$7(B" "") ("she" "$B$7$'(B" "") ("sha" "$B$7$c(B" "") ("se" "$B$;(B" "")
    ("sa" "$B$5(B" "") ("ryu" "$B$j$e(B" "") ("ryo" "$B$j$g(B" "") ("ryi" "$B$j$#(B" "")
    ("rye" "$B$j$'(B" "") ("rya" "$B$j$c(B" "") ("ru" "$B$k(B" "") ("rr" "$B$C(B" "r")
    ("ro" "$B$m(B" "") ("ri" "$B$j(B" "") ("re" "$B$l(B" "") ("ra" "$B$i(B" "") ("qq" "$B$C(B" "q")
    ("pyu" "$B$T$e(B" "") ("pyo" "$B$T$g(B" "") ("pyi" "$B$T$#(B" "") ("pye" "$B$T$'(B" "")
    ("pya" "$B$T$c(B" "") ("pu" "$B$W(B" "") ("pp" "$B$C(B" "p") ("po" "$B$](B" "")
    ("pi" "$B$T(B" "") ("pe" "$B$Z(B" "") ("pa" "$B$Q(B" "") ("o" "$B$*(B" "")
    ("nyu" "$B$K$e(B" "") ("nyo" "$B$K$g(B" "") ("nyi" "$B$K$#(B" "") ("nye" "$B$K$'(B" "")
    ("nya" "$B$K$c(B" "") ("n'" "$B$s(B" "") ("nu" "$B$L(B" "") ("no" "$B$N(B" "")
    ("nn" "$B$s(B" "") ("ni" "$B$K(B" "") ("ne" "$B$M(B" "") ("na" "$B$J(B" "") ("n" "$B$s(B" "")
    ("myu" "$B$_$e(B" "") ("myo" "$B$_$g(B" "") ("myi" "$B$_$#(B" "") ("mye" "$B$_$'(B" "")
    ("mya" "$B$_$c(B" "") ("mu" "$B$`(B" "") ("mo" "$B$b(B" "") ("mn" "$B$s(B" "")
    ("mm" "$B$C(B" "m") ("mi" "$B$_(B" "") ("me" "$B$a(B" "") ("ma" "$B$^(B" "")
    ("lyu" "$B$j$e(B" "") ("lyo" "$B$j$g(B" "") ("lyi" "$B$j$#(B" "") ("lye" "$B$j$'(B" "")
    ("lya" "$B$j$c(B" "") ("lu" "$B$k(B" "") ("lo" "$B$m(B" "") ("li" "$B$j(B" "")
    ("le" "$B$l(B" "") ("la" "$B$i(B" "") ("kyu" "$B$-$e(B" "") ("kyo" "$B$-$g(B" "")
    ("kyi" "$B$-$#(B" "") ("kye" "$B$-$'(B" "") ("kya" "$B$-$c(B" "") ("ku" "$B$/(B" "")
    ("ko" "$B$3(B" "") ("kk" "$B$C(B" "k") ("ki" "$B$-(B" "") ("ke" "$B$1(B" "") ("ka" "$B$+(B" "")
    ("jyu" "$B$8$e(B" "") ("jyo" "$B$8$g(B" "") ("jyi" "$B$8$#(B" "") ("jye" "$B$8$'(B" "")
    ("jya" "$B$8$c(B" "") ("ju" "$B$8$e(B" "") ("jo" "$B$8$g(B" "") ("jj" "$B$C(B" "j")
    ("ji" "$B$8(B" "") ("je" "$B$8$'(B" "") ("ja" "$B$8$c(B" "") ("i" "$B$$(B" "")
    ("hyu" "$B$R$e(B" "") ("hyo" "$B$R$g(B" "") ("hyi" "$B$R$#(B" "") ("hye" "$B$R$'(B" "")
    ("hya" "$B$R$c(B" "") ("hu" "$B$U(B" "") ("ho" "$B$[(B" "") ("hi" "$B$R(B" "")
    ("hh" "$B$C(B" "h") ("he" "$B$X(B" "") ("ha" "$B$O(B" "") ("gyu" "$B$.$e(B" "")
    ("gyo" "$B$.$g(B" "") ("gyi" "$B$.$#(B" "") ("gye" "$B$.$'(B" "") ("gya" "$B$.$c(B" "")
    ("gwu" "$B$0$%(B" "") ("gwo" "$B$0$)(B" "") ("gwi" "$B$0$#(B" "") ("gwe" "$B$0$'(B" "")
    ("gwa" "$B$0$!(B" "") ("gu" "$B$0(B" "") ("go" "$B$4(B" "") ("gi" "$B$.(B" "")
    ("gg" "$B$C(B" "g") ("ge" "$B$2(B" "") ("ga" "$B$,(B" "") ("fu" "$B$U(B" "")
    ("fo" "$B$U$)(B" "") ("fi" "$B$U$#(B" "") ("ff" "$B$C(B" "f") ("fe" "$B$U$'(B" "")
    ("fa" "$B$U$!(B" "") ("e" "$B$((B" "") ("dyu" "$B$B$e(B" "") ("dyo" "$B$B$g(B" "")
    ("dyi" "$B$B$#(B" "") ("dye" "$B$B$'(B" "") ("dya" "$B$B$c(B" "") ("du" "$B$E(B" "")
    ("do" "$B$I(B" "") ("di" "$B$B(B" "") ("dhu" "$B$G$e(B" "") ("dho" "$B$G$g(B" "")
    ("dhi" "$B$G$#(B" "") ("dhe" "$B$G$'(B" "") ("dha" "$B$G$c(B" "") ("de" "$B$G(B" "")
    ("dd" "$B$C(B" "d") ("da" "$B$@(B" "") ("cyu" "$B$A$e(B" "") ("cyo" "$B$A$g(B" "")
    ("cyi" "$B$A$#(B" "") ("cye" "$B$A$'(B" "") ("cya" "$B$A$c(B" "") ("cu" "$B$/(B" "")
    ("co" "$B$3(B" "") ("chu" "$B$A$e(B" "") ("cho" "$B$A$g(B" "") ("chi" "$B$A(B" "")
    ("che" "$B$A$'(B" "") ("cha" "$B$A$c(B" "") ("cc" "$B$C(B" "c") ("ca" "$B$+(B" "")
    ("byu" "$B$S$e(B" "") ("byo" "$B$S$g(B" "") ("byi" "$B$S$#(B" "") ("bye" "$B$S$'(B" "")
    ("bya" "$B$S$c(B" "") ("bu" "$B$V(B" "") ("bo" "$B$\(B" "") ("bi" "$B$S(B" "")
    ("be" "$B$Y(B" "") ("bb" "$B$C(B" "b") ("ba" "$B$P(B" "") ("a" "$B$"(B" "") ("`" "$B!.(B" "")
    ("_" "$B!2(B" "") ("^" "$B!0(B" "") ("]" "$B!W(B" "") ("\\" "$B!o(B" "") ("[" "$B!V(B" "")
    ("@~" "$B!A(B" "") ("@}" "$B!Q(B" "") ("@||" "$B!B(B" "") ("@|" "$B!C(B" "") ("@{" "$B!P(B" "")
    ("@]" "$B!O(B" "") ("@\\" "$B!@(B" "") ("@[" "$B!N(B" "") ("@@" "$B!!(B" "")
    ("@568" "$B$?$m$&(B88$B!&(B1" "") ("@3" "$B!D(B" "") ("@2" "$B!E(B" "") ("@/" "$B!&(B" "")
    ("@." "$B!%(B" "") ("@-" "$B!](B" "") ("@," "$B!$(B" "") ("@)" "$B!K(B" "") ("@(" "$B!J(B" "")
    ("@" "$B!w(B" "") ("?" "$B!)(B" "") (">" "$B!d(B" "") ("=" "$B!a(B" "") ("<" "$B!c(B" "")
    (";" "$B!((B" "") (":" "$B!'(B" "") ("9" "$B#9(B" "") ("8" "$B#8(B" "") ("7" "$B#7(B" "")
    ("6" "$B#6(B" "") ("5" "$B#5(B" "") ("4" "$B#4(B" "") ("3" "$B#3(B" "") ("2" "$B#2(B" "")
    ("1" "$B#1(B" "") ("0" "$B#0(B" "") ("/" "$B!?(B" "") ("." "$B!#(B" "") ("-" "$B!<(B" "")
    ("," "$B!"(B" "") ("+" "$B!\(B" "") ("*" "$B!v(B" "") ("&" "$B!u(B" "") ("%" "$B!s(B" "")
    ("$" "$B!p(B" "") ("#" "$B!t(B" "") ("!" "$B!*(B" "") (" " "$B!!(B" "")))

;; default $B$R$i2>L>(B-$B%m!<%^;zJQ49%F!<%V%k(B
(defconst yc-default-Hr-table 
  '(("$B$C(B" . "xtsu")
    ("$B$"(B" . "a")  ("$B$$(B" . "i")  ("$B$&(B" . "u")  ("$B$((B" . "e")  ("$B$*(B" . "o")
    ("$B$!(B" . "xa") ("$B$#(B" . "xi") ("$B$%(B" . "xu") ("$B$'(B" . "xe") ("$B$)(B" . "xo")
    ("$B$n(B" . "xwa") ("$B$c(B" . "xya") ("$B$e(B" . "xyu") ("$B$g(B" . "xyo")
    ("$B$&!+$!(B" . "va") ("$B$&!+$#(B" . "vi") ("$B$&!+(B" . "vu") ("$B$&!+$'(B" . "ve")
    ("$B$&!+$)(B" . "vo") ("$B$+(B" . "ka") ("$B$-(B" . "ki") ("$B$/(B" . "ku") ("$B$1(B" . "ke")
    ("$B$3(B" . "ko") ("$B$,(B" . "ga") ("$B$.(B" . "gi") ("$B$0(B" . "gu") ("$B$2(B" . "ge")
    ("$B$4(B" . "go") ("$B$-$c(B" . "kya") ("$B$-$#(B" . "kyi") ("$B$-$e(B" . "kyu")
    ("$B$-$'(B" . "kye") ("$B$-$g(B" . "kyo") ("$B$.$c(B" . "gya") ("$B$.$#(B" . "gyi")
    ("$B$.$e(B" . "gyu") ("$B$.$'(B" . "gye") ("$B$.$g(B" . "gyo") ("$B$0$!(B" . "gwa")
    ("$B$0$#(B" . "gwi") ("$B$0$%(B" . "gwu") ("$B$0$'(B" . "gwe") ("$B$0$)(B" . "gwo")
    ("$B$5(B" . "sa") ("$B$7(B" . "shi") ("$B$9(B" . "su") ("$B$;(B" . "se") ("$B$=(B" . "so")
    ("$B$6(B" . "za") ("$B$8(B" . "ji") ("$B$:(B" . "zu") ("$B$<(B" . "ze") ("$B$>(B" . "zo")
    ("$B$7$c(B" . "sha") ("$B$7$#(B" . "syi") ("$B$7$e(B" . "shu") ("$B$7$'(B" . "she")
    ("$B$7$g(B" . "sho") ("$B$8$c(B" . "ja") ("$B$8$#(B" . "jyi") ("$B$8$e(B" . "ju")
    ("$B$8$'(B" . "je") ("$B$8$g(B" . "jo") ("$B$?(B" . "ta") ("$B$A(B" . "ti") ("$B$D(B" . "tu")
    ("$B$F(B" . "te") ("$B$H(B" . "to") ("$B$@(B" . "da") ("$B$B(B" . "di") ("$B$E(B" . "du")
    ("$B$G(B" . "de") ("$B$I(B" . "do") ("$B$A$c(B" . "cha") ("$B$A$#(B" . "cyi")
    ("$B$A$e(B" . "chu") ("$B$A$'(B" . "che") ("$B$A$g(B" . "cho") ("$B$B$c(B" . "dya")
    ("$B$B$#(B" . "dyi") ("$B$B$e(B" . "dyu") ("$B$B$'(B" . "dye") ("$B$B$g(B" . "dyo")
    ("$B$D$!(B" . "tsa") ("$B$D$#(B" . "tsi") ("$B$D$'(B" . "tse") ("$B$D$)(B" . "tso")
    ("$B$F$c(B" . "tha") ("$B$F$#(B" . "thi") ("$B$F$e(B" . "thu") ("$B$F$'(B" . "the")
    ("$B$F$g(B" . "tho") ("$B$G$c(B" . "dha") ("$B$G$#(B" . "dhi") ("$B$G$e(B" . "dhu")
    ("$B$G$'(B" . "dhe") ("$B$G$g(B" . "dho") ("$B$J(B" . "na") ("$B$K(B" . "ni") ("$B$L(B" . "nu")
    ("$B$M(B" . "ne") ("$B$N(B" . "no") ("$B$K$c(B" . "nya") ("$B$K$#(B" . "nyi")
    ("$B$K$e(B" . "nyu") ("$B$K$'(B" . "nye") ("$B$K$g(B" . "nyo") ("$B$O(B" . "ha")
    ("$B$R(B" . "hi") ("$B$U(B" . "fu") ("$B$X(B" . "he") ("$B$[(B" . "ho") ("$B$P(B" . "ba")
    ("$B$S(B" . "bi") ("$B$V(B" . "bu") ("$B$Y(B" . "be") ("$B$\(B" . "bo") ("$B$Q(B" . "pa")
    ("$B$T(B" . "pi") ("$B$W(B" . "pu") ("$B$Z(B" . "pe") ("$B$](B" . "po") ("$B$R$c(B" . "hya")
    ("$B$R$#(B" . "hyi") ("$B$R$e(B" . "hyu") ("$B$R$'(B" . "hye") ("$B$R$g(B" . "hyo")
    ("$B$S$c(B" . "bya") ("$B$S$#(B" . "byi") ("$B$S$e(B" . "byu") ("$B$S$'(B" . "bye")
    ("$B$S$g(B" . "byo") ("$B$T$c(B" . "pya") ("$B$T$#(B" . "pyi") ("$B$T$e(B" . "pyu")
    ("$B$T$'(B" . "pye") ("$B$T$g(B" . "pyo") ("$B$U$!(B" . "fa") ("$B$U$#(B" . "fi")
    ("$B$U$'(B" . "fe") ("$B$U$)(B" . "fo") ("$B$^(B" . "ma") ("$B$_(B" . "mi") ("$B$`(B" . "mu")
    ("$B$a(B" . "me") ("$B$b(B" . "mo") ("$B$_$c(B" . "mya") ("$B$_$#(B" . "myi")
    ("$B$_$e(B" . "myu") ("$B$_$'(B" . "mye") ("$B$_$g(B" . "myo") ("$B$d(B" . "ya")
    ("$B$f(B" . "yu") ("$B$$$'(B" . "ye") ("$B$h(B" . "yo") ("$B$i(B" . "ra") ("$B$j(B" . "ri")
    ("$B$k(B" . "ru") ("$B$l(B" . "re") ("$B$m(B" . "ro") ("$B$j$c(B" . "rya") ("$B$j$#(B" . "ryi")
    ("$B$j$e(B" . "ryu") ("$B$j$'(B" . "rye") ("$B$j$g(B" . "ryo") ("$B$o(B" . "wa")
    ("$B$p(B" . "wi") ("$B$q(B" . "we") ("$B$r(B" . "wo") ("$B$s(B" . "n'") ("$B!<(B" . "-")
    ("$B!V(B" . "[") ("$B!W(B" . "]") ("$B!"(B" . ",") ("$B!#(B" . ".") ("$B!o(B" . "\\")
    ("$B!I(B" . "\"") ("$B!.(B" . "`")))

;; $B$R$i$,$J(B-$B%+%?%+%JJQ49%F!<%V%k(B $BJ8;zNs(B
;(defconst yc-HkST
;  '(("$B$&!+(B" . "$B%t(B")))

;; $B$R$i$,$J(B-$B%+%?%+%JJQ49%F!<%V%k(B $BJ8;z(B
(defconst yc-HkT
  '((?$B$!(B . ?$B%!(B) (?$B$#(B . ?$B%#(B) (?$B$%(B . ?$B%%(B) (?$B$'(B . ?$B%'(B) (?$B$)(B . ?$B%)(B)
    (?$B$"(B . ?$B%"(B) (?$B$$(B . ?$B%$(B) (?$B$&(B . ?$B%&(B) (?$B$((B . ?$B%((B) (?$B$*(B . ?$B%*(B)
    (?$B$+(B . ?$B%+(B) (?$B$-(B . ?$B%-(B) (?$B$/(B . ?$B%/(B) (?$B$1(B . ?$B%1(B) (?$B$3(B . ?$B%3(B)
    (?$B$,(B . ?$B%,(B) (?$B$.(B . ?$B%.(B) (?$B$0(B . ?$B%0(B) (?$B$2(B . ?$B%2(B) (?$B$4(B . ?$B%4(B)
    (?$B$5(B . ?$B%5(B) (?$B$7(B . ?$B%7(B) (?$B$9(B . ?$B%9(B) (?$B$;(B . ?$B%;(B) (?$B$=(B . ?$B%=(B)
    (?$B$6(B . ?$B%6(B) (?$B$8(B . ?$B%8(B) (?$B$:(B . ?$B%:(B) (?$B$<(B . ?$B%<(B) (?$B$>(B . ?$B%>(B)
    (?$B$?(B . ?$B%?(B) (?$B$A(B . ?$B%A(B) (?$B$D(B . ?$B%D(B) (?$B$F(B . ?$B%F(B) (?$B$H(B . ?$B%H(B)
                            (?$B$C(B . ?$B%C(B)
    (?$B$@(B . ?$B%@(B) (?$B$B(B . ?$B%B(B) (?$B$E(B . ?$B%E(B) (?$B$G(B . ?$B%G(B) (?$B$I(B . ?$B%I(B)
    (?$B$J(B . ?$B%J(B) (?$B$K(B . ?$B%K(B) (?$B$L(B . ?$B%L(B) (?$B$M(B . ?$B%M(B) (?$B$N(B . ?$B%N(B)
    (?$B$O(B . ?$B%O(B) (?$B$R(B . ?$B%R(B) (?$B$U(B . ?$B%U(B) (?$B$X(B . ?$B%X(B) (?$B$[(B . ?$B%[(B)
    (?$B$P(B . ?$B%P(B) (?$B$S(B . ?$B%S(B) (?$B$V(B . ?$B%V(B) (?$B$Y(B . ?$B%Y(B) (?$B$\(B . ?$B%\(B)
    (?$B$Q(B . ?$B%Q(B) (?$B$T(B . ?$B%T(B) (?$B$W(B . ?$B%W(B) (?$B$Z(B . ?$B%Z(B) (?$B$](B . ?$B%](B)
    (?$B$^(B . ?$B%^(B) (?$B$_(B . ?$B%_(B) (?$B$`(B . ?$B%`(B) (?$B$a(B . ?$B%a(B) (?$B$b(B . ?$B%b(B)
    (?$B$c(B . ?$B%c(B)             (?$B$e(B . ?$B%e(B)             (?$B$g(B . ?$B%g(B)
    (?$B$d(B . ?$B%d(B)             (?$B$f(B . ?$B%f(B)             (?$B$h(B . ?$B%h(B)
    (?$B$i(B . ?$B%i(B) (?$B$j(B . ?$B%j(B) (?$B$k(B . ?$B%k(B) (?$B$l(B . ?$B%l(B) (?$B$m(B . ?$B%m(B)
    (?$B$o(B . ?$B%o(B) (?$B$p(B . ?$B%p(B)             (?$B$q(B . ?$B%q(B) (?$B$r(B . ?$B%r(B)
    (?$B$s(B . ?$B%s(B)))

;; $B$R$i$,$J(B-$BH>3Q%+%?%+%JJQ49%F!<%V%k(B $BJ8;z(B
(defconst yc-HhT
  '((?$B$!(B . "(I'(B")  (?$B$#(B . "(I((B")  (?$B$%(B . "(I)(B")  (?$B$'(B . "(I*(B")  (?$B$)(B . "(I+(B")
    (?$B$"(B . "(I1(B")  (?$B$$(B . "(I2(B")  (?$B$&(B . "(I3(B")  (?$B$((B . "(I4(B")  (?$B$*(B . "(I5(B")
    (?$B$+(B . "(I6(B")  (?$B$-(B . "(I7(B")  (?$B$/(B . "(I8(B")  (?$B$1(B . "(I9(B")  (?$B$3(B . "(I:(B")
    (?$B$,(B . "(I6^(B") (?$B$.(B . "(I7^(B") (?$B$0(B . "(I8^(B") (?$B$2(B . "(I9^(B") (?$B$4(B . "(I:^(B")
    (?$B$5(B . "(I;(B")  (?$B$7(B . "(I<(B")  (?$B$9(B . "(I=(B")  (?$B$;(B . "(I>(B")  (?$B$=(B . "(I?(B")
    (?$B$6(B . "(I;^(B") (?$B$8(B . "(I<^(B") (?$B$:(B . "(I=^(B") (?$B$<(B . "(I>^(B") (?$B$>(B . "(I?^(B")
    (?$B$?(B . "(I@(B")  (?$B$A(B . "(IA(B")  (?$B$D(B . "(IB(B")  (?$B$F(B . "(IC(B")  (?$B$H(B . "(ID(B")
                              (?$B$C(B . "(I/(B")
    (?$B$@(B . "(I@^(B") (?$B$B(B . "(IA^(B") (?$B$E(B . "(IB^(B") (?$B$G(B . "(IC^(B") (?$B$I(B . "(ID^(B")
    (?$B$J(B . "(IE(B")  (?$B$K(B . "(IF(B")  (?$B$L(B . "(IG(B")  (?$B$M(B . "(IH(B")  (?$B$N(B . "(II(B")
    (?$B$O(B . "(IJ(B")  (?$B$R(B . "(IK(B")  (?$B$U(B . "(IL(B")  (?$B$X(B . "(IM(B")  (?$B$[(B . "(IN(B")
    (?$B$P(B . "(IJ^(B") (?$B$S(B . "(IK^(B") (?$B$V(B . "(IL^(B") (?$B$Y(B . "(IM^(B") (?$B$\(B . "(IN^(B")
    (?$B$Q(B . "(IJ_(B") (?$B$T(B . "(IK_(B") (?$B$W(B . "(IL_(B") (?$B$Z(B . "(IM_(B") (?$B$](B . "(IN_(B")
    (?$B$^(B . "(IO(B")  (?$B$_(B . "(IP(B")  (?$B$`(B . "(IQ(B")  (?$B$a(B . "(IR(B")  (?$B$b(B . "(IS(B")
    (?$B$c(B . "(I,(B")               (?$B$e(B . "(I-(B")               (?$B$g(B . "(I.(B")
    (?$B$d(B . "(IT(B")               (?$B$f(B . "(IU(B")               (?$B$h(B . "(IV(B")
    (?$B$i(B . "(IW(B")  (?$B$j(B . "(IX(B")  (?$B$k(B . "(IY(B")  (?$B$l(B . "(IZ(B")  (?$B$m(B . "(I[(B")
    (?$B$o(B . "(I\(B")  (?$B$p(B . "(I2(B")               (?$B$q(B . "(I4(B")  (?$B$r(B . "(I&(B")
    (?$B$s(B . "(I](B")  (?$B!<(B . "(I0(B")))

;; $BH>3Q(B-$BA43QJQ49%F!<%V%k(B
(defconst yc-aAT
  '(;(?(I^(B . ?$B!+(B)
    (?! . ?$B!*(B) (?\" . ?$B!m(B) (?# . ?$B!t(B) (?$ . ?$B!p(B) (?% . ?$B!s(B) (?& . ?$B!u(B)
    (?\' . ?$B!G(B) (?\( . ?$B!J(B) (?\) . ?$B!K(B) (?* . ?$B!v(B) (?+ . ?$B!\(B) (?, . ?$B!$(B)
    (?- . ?$B!](B) (?. . ?$B!%(B) (?/ . ?$B!?(B) (?0 . ?$B#0(B) (?1 . ?$B#1(B) (?2 . ?$B#2(B)
    (?3 . ?$B#3(B) (?4 . ?$B#4(B) (?5 . ?$B#5(B) (?6 . ?$B#6(B) (?7 . ?$B#7(B) (?8 . ?$B#8(B)
    (?9 . ?$B#9(B) (?: . ?$B!'(B) (?\; . ?$B!((B) (?< . ?$B!c(B) (?= . ?$B!a(B) (?> . ?$B!d(B)
    (?? . ?$B!)(B) (?@ . ?$B!w(B) (?A . ?$B#A(B) (?B . ?$B#B(B) (?C . ?$B#C(B) (?D . ?$B#D(B)
    (?E . ?$B#E(B) (?F . ?$B#F(B) (?G . ?$B#G(B) (?H . ?$B#H(B) (?I . ?$B#I(B) (?J . ?$B#J(B)
    (?K . ?$B#K(B) (?L . ?$B#L(B) (?M . ?$B#M(B) (?N . ?$B#N(B) (?O . ?$B#O(B) (?P . ?$B#P(B)
    (?Q . ?$B#Q(B) (?R . ?$B#R(B) (?S . ?$B#S(B) (?T . ?$B#T(B) (?U . ?$B#U(B) (?V . ?$B#V(B)
    (?W . ?$B#W(B) (?X . ?$B#X(B) (?Y . ?$B#Y(B) (?Z . ?$B#Z(B) (?\[ . ?$B!N(B) (?\\ . ?$B!@(B)
    (?\] . ?$B!O(B) (?^ . ?$B!0(B) (?_ . ?$B!2(B) (?` . ?$B!F(B) (?a . ?$B#a(B) (?b . ?$B#b(B)
    (?c . ?$B#c(B) (?d . ?$B#d(B) (?e . ?$B#e(B) (?f . ?$B#f(B) (?g . ?$B#g(B) (?h . ?$B#h(B)
    (?i . ?$B#i(B) (?j . ?$B#j(B) (?k . ?$B#k(B) (?l . ?$B#l(B) (?m . ?$B#m(B) (?n . ?$B#n(B)
    (?o . ?$B#o(B) (?p . ?$B#p(B) (?q . ?$B#q(B) (?r . ?$B#r(B) (?s . ?$B#s(B) (?t . ?$B#t(B)
    (?u . ?$B#u(B) (?v . ?$B#v(B) (?w . ?$B#w(B) (?x . ?$B#x(B) (?y . ?$B#y(B) (?z . ?$B#z(B)
    (?{ . ?$B!P(B) (?| . ?$B!C(B) (?} . ?$B!Q(B) (?~ . ?$B!1(B)))


(defun yc-substitute-string (src dst str)
  (let ((pos 0))
    (while (string-match src str pos)
      (setq pos (+ (match-beginning 0) (length dst))
            str (concat (substring str 0 (match-beginning 0))
			dst
                        (substring str (match-end 0)))))
    str))

;; $B$R$i$,$J(B-$B%+%?%+%JJQ49(B
(defun yc-conv-Hk (str)
  (yc-substitute-string
   "$B%&!+(B" "$B%t(B" 
   (concat (mapcar (lambda (c) (let ((l (assq c yc-HkT))) (if l (cdr l) c)))
		   (append str nil)))))

;; $B$R$i$,$J(B-$BH>3Q%+%JJQ49(B
(defun yc-conv-Hh (str)
  (mapconcat (lambda (c) (let ((l (assq c yc-HhT)))
			   (if l (cdr l) (char-to-string c))))
	     (append str nil) ""))

;; $B%+%?%+%J(B-$B$R$i$,$JJQ49(B
(defun yc-conv-kH (str)
  (concat (mapcar (lambda (c) (let ((l (rassq c yc-HkT))) (if l (car l) c)))
		  (append (yc-substitute-string "$B%t(B" "$B%&!+(B" str) nil))))

;; alphabet-$B#a#l#p#h#a#b#e#tJQ49(B
(defun yc-conv-aA (str)
  (concat (mapcar (lambda (c) (let ((l (assq c yc-aAT))) (if l (cdr l) c)))
		  (append str nil))))

;; $B#a#l#p#h#a#b#e#t(B-alphabet$BJQ49(B
(defun yc-conv-Aa (str)
  (concat (mapcar (lambda (c) (let ((l (rassq c yc-aAT))) (if l (car l) c)))
		  (append str nil))))

;;
;; $B$R$i$,$J(B-romaji$BJQ49(B
;;
(defvar yc-Hr-table nil)
(defvar yc-Hr-item-max 0)

(defun yc-Hr-table-pack (Hr-table rH-table)
  (let ((table Hr-table)
	(new))
    (while table
      (when (car (assoc (cdar table) rH-table))
	(setq new (cons (car table) new)))
      (setq table (cdr table)))
    new))

(defun yc-Hr-item-length (Hr-table)
  (let ((n 0))
    (while Hr-table
      (setq n (max (yc-strlen (caar Hr-table)) n))
      (setq Hr-table (cdr Hr-table)))
    n))

(defun yc-Hr-table-separate (Hr-table)
  (let ((new))
    (while Hr-table
      (let ((idx (yc-strlen (caar Hr-table))))
	(when (and (null (nth (1- idx) new)) (< (length new) idx))
	  (setq new (nconc new (make-list (- idx (length new)) nil))))
	(setcar (nthcdr (1- idx) new) (cons (car Hr-table) (nth (1- idx) new)))
	(setq Hr-table (cdr Hr-table))))
    new))

(defun yc-Hr-table-setup ()
  (let ((l (yc-Hr-table-pack yc-default-Hr-table yc-default-rH-table)))
    (setq yc-Hr-table (yc-Hr-table-separate l)
	  yc-Hr-item-max (yc-Hr-item-length l))))

(defun yc-conv-Hr-internal (hira)
  (let ((l (string-to-list hira)))
    (while (and l (not (assoc (concat l) (nth (1- (length l)) yc-Hr-table))))
      (setq l (reverse (cdr (reverse l)))))
    (when l (assoc (concat l) (nth (1- (length l)) yc-Hr-table)))))

(defun yc-subsequence (lst bgn end)
  (and lst
       (if (= bgn end)
	   nil
	 (let ((r (nthcdr bgn (copy-sequence lst))))
	   (if (null (nthcdr (- end bgn 1) r))
	       nil
	     (setcdr (nthcdr (- end bgn 1) r) nil)
	     r)))))

(defun yc-conv-Hr (hira)
  (let ((l (string-to-list hira))
	(roma))
    (while l
      (cond ((equal (car l) ?$B$C(B) (setq roma (cons -2 roma) l (cdr l)))
	    ((equal (car l) ?$B$s(B) (setq roma (cons -1 roma) l (cdr l)))
	    (t
	     (let ((hit (yc-conv-Hr-internal
			 (concat (yc-subsequence l 0 (min (length l)
							  yc-Hr-item-max))))))
	       (if hit
		   (setq roma (cons (cdr hit) roma)
			 l (nthcdr (length (string-to-list (car hit))) l))
		 (setq roma (cons (char-to-string (car l)) roma)
		       l (cdr l)))))) )
    (setq l roma roma nil)
;    (yc-debug l)
    (let ((xtsu (yc-conv-Hr-internal "$B$C(B"))
	  (nn (yc-conv-Hr-internal "$B$s(B")))
      (while l
	(let ((c (and (car roma) (or (integerp (car roma)) (car roma))
		      (car (string-to-list (car roma))))))
	  (setq roma (cons (cond ((not (integerp (car l))) (car l))
				 ((and (= (car l) -1) ; $B$s(B+$BJl2;(B
				       c
				       (memq c '(-1 ?n ?a ?i ?u ?e ?o)))
				  (cdr nn))
				 ((= (car l) -1) "n") ; $B$s(B+$B;R2;(B or $B:G=*(B
				 ((and (= (car l) -2) ; $B$C(B+$B;R2;(B
				       c
				       (not (memq c '(?n ?a ?i ?u ?e ?o))))
				  (char-to-string c))
				 ((= (car l) -2) ; $B$C(B+$BJl2;(B or $B:G=*(B
				  (cdr xtsu))) roma)
		l (cdr l)))))
    (apply 'concat roma)))

;;
;; romaji-$B$R$i$,$JJQ49(B
;;
(defun yc-read-string-from-file (file)
  (let* ((suffix (file-name-extension file))
	 ;; emacs-20.x
	 ;;(auto-coding-alist
	 ;; (if suffix
	 ;;     (list (cons (concat "\\." suffix) 'japanese-iso-8bit))
	 ;;   auto-coding-alist))
	 (auto-coding-alist
	  (list (cons "" 'japanese-iso-8bit)))
	 ;; XEmacs-20.x
	 ;;(file-coding-system-alist
	 ;; (if suffix
	 ;;     (list (cons (concat "\\." suffix) 'euc-jp))
	 ;;   file-coding-system-alist))
	 (file-coding-system-alist
	  (list (cons "" 'euc-jp)))

	 (buf (get-file-buffer file))
         (flag (not buf))
         (buf (if buf buf
		(prog1 (find-file-noselect file) (message ""))))
         (str))
    (save-excursion
      (set-buffer buf)
      (setq str (buffer-string))
      (when flag (kill-buffer buf)))
    str))

(defun yc-hex-to-char (hex)
  (let ((l (string-to-list hex))
	(new))
    (while (>= (length l) 3)
      (if (and (= (nth 0 l) ?x)
	       (or (and (<= ?0 (nth 1 l)) (<= (nth 1 l) ?9))
		   (and (<= ?A (nth 1 l)) (<= (nth 1 l) ?F)))
	       (or (and (<= ?0 (nth 2 l)) (<= (nth 2 l) ?9))
		   (and (<= ?A (nth 2 l)) (<= (nth 2 l) ?F))))
	  (setq new (concat
		     new
		     (char-to-string
		      (+ (* 16 (cond ((and (<= ?0 (nth 1 l)) (<= (nth 1 l) ?9))
				      (- (nth 1 l) ?0))
				     ((and (<= ?A (nth 1 l)) (<= (nth 1 l) ?F))
				      (+ (- (nth 1 l) ?A) 10))))
			 (cond ((and (<= ?0 (nth 2 l)) (<= (nth 2 l) ?9))
				(- (nth 2 l) ?0))
			       ((and (<= ?A (nth 2 l)) (<= (nth 2 l) ?F))
				(+ (- (nth 2 l) ?A) 10))))))
		l (nthcdr 3 l))
	(setq new (concat new (char-to-string (car l)))
	      l (cdr l))))
    (concat new (concat l))))

(defun yc-rH-convert-dictionary (dic)
  (and (file-exists-p dic)
       (let ((str (yc-read-string-from-file dic)))
	 (setq yc-rH-table
	       (let ((l (split-string
			 (substring str 7)
			 "\000"))
		     (ll))
		 (while l
		   (when(/= (length (car l)) 0)
		     (setq ll (cons (list (yc-hex-to-char (car l))
					  (car (cdr l))
					  (car (cdr (cdr l)))) ll)))
		   (setq l (nthcdr 3 l)))
		 ll)))))

;; returns ((?c . "a"))
(defun yc-make-entry (seq str nlst)
  (if (listp nlst)
      ;; nlst $B$,(B list $B$b$7$/$O(B nil $B$N;~(B
      (let ((a (assq (string-to-char seq) nlst)) ; nlst $B$KB8:_$9$k$+$N(B check
	    (n nlst)			; nlst $B$KB8:_$7$?$H$-$NB8:_ItJ,0J9_(B
	    (m nil))			; nlst $B$KB8:_$7$?$H$-$NB8:_ItJ,0JA0(B
	(if a
	    (progn
	      (while (and (car n) (not (eq (caar n) (string-to-char seq))))
		(setq m (append m (list (car n)))
		     n (cdr n)))
	      (if (= (length seq) 1)
		  ;; nlst $B$KB8:_$7(B seq $B$,(B 1 $BJ8;z(B
		  (append m
			  (list (append (list (caar n))
					(list (cons nil str)) (cdar n)))
			  (cdr n))
		;; nlst $B$KB8:_$7(B seq $B$,(B 2 $BJ8;z0J>e(B
		(append m
			(list (append
			       (list (string-to-char seq))
			       (yc-make-entry
				(yc-substring seq 1) str (cdar n))))
			(cdr n))))
	  (if (= (length seq) 1)
	      ;; nlst $B$KB8:_$;$:(B 1 $BJ8;z(B
	      (append nlst (list (cons (string-to-char seq) str)))
	    ;; nlst $B$KB8:_$;$:(B 2 $BJ8;z0J>e(B
	    (append nlst
		    (list (append (list (string-to-char seq))
				  (yc-make-entry
				   (yc-substring seq 1) str nil)))))))
    (if (= (length seq) 1)
	;; nlst $B$,(B listp $B$G$J$/(B 1 $BJ8;z(B
	(list (cons nil nlst) (cons (string-to-char seq) str))
      ;; nlst $B$,(B listp $B$G$J$/(B 2 $BJ8;z0J>e(B
      (list (cons nil nlst)
	    (cons (string-to-char seq)
		  (yc-make-entry (yc-substring seq 1) str nil))))))

; (defun yc-countup-entry (dic)
;   (if (and (listp dic) (listp (cdr dic)))
;       (let ((s 0)
; 	    (d dic))
; 	(while (car d)
; 	  (setq s (+ s (* 10 (yc-countup-entry (car d))))
; 		d (cdr d)))
; 	s)
;     1))

; (defun yc-sort-entry (dic)
;   (if (and (listp dic) (listp (cdr dic)))
;       (let ((i 0))
; 	(while (< i (1- (length dic)))
; 	  (setcdr (elt dic i) (yc-sort-entry (cdr (elt dic i))))
; 	  (let ((j (1+ i)))
; 	    (while (< j (length dic))
; 	      (when (< (yc-countup-entry (elt dic i))
; 		       (yc-countup-entry (elt dic j)))
; 		(let ((tmp (elt dic i)))
; 		  (setcar (nthcdr i dic) (elt dic j))
; 		  (setcar (nthcdr j dic) tmp)))
; 	      (setq j (1+ j))))
; 	  (setq i (1+ i)))
; 	dic)
;     dic))

(defun yc-rH-make-lookup-table (entries)
  (let ((entry nil)
	(dic nil))
    (while (setq entry (car entries))
      (when (nth 2 entry)
	(setq dic (yc-make-entry (nth 0 entry)
				 (concat (nth 1 entry) "\177" (nth 2 entry))
				 dic)
	      entries (cdr entries))))
    dic))
;    (yc-sort-entry dic)))


(defun yc-lookup-rH-internal (seq dic opt)
  (unless (or (not (stringp seq)) (= (yc-strlen seq) 0))
    (let ((c nil) (r nil) (a nil) (d dic))
      (while (and (setq c (string-to-char seq))
		  (setq a (assq c d))
		  (listp (cdr a)))
	(setq d a
	      r (concat r (yc-substring seq 0 1))
	      seq (substring seq 1)))
      (if (and c (/= c 0))
	  (if a
	      (cons (cdr a) (yc-substring seq 1))
	    (if (setq a (assq nil d))
		(cons (cdr a) seq)
	      (if r
		  (cons (yc-substring r 0 1) (concat (yc-substring r 1) seq))
;		  (cons r seq) ; 2003/12/25
		(cons (char-to-string c)
		      (yc-substring seq 1)))))
	(if (and (not opt) (setq a (assq nil d)))
	    (cons (cdr a) "")
	  (cons nil r))))))

;; appended 01/12/29 by matz@ruby-lang.org
(defun yc-split-string (str sep)
  (if (string-match sep str)
      (list (substring str 0 (match-beginning 0))
            (substring str (match-end 0)))
    (list str)))

;; modified 01/12/29 by matz@ruby-lang.org
(defun yc-lookup-rH (romaji yc-yomi-dic opt)
  (let ((r (yc-lookup-rH-internal romaji yc-yomi-dic opt))
        (c nil)
        (l nil))
    (when r
      (setq c (car r))
      (if (and c (= (length (setq l (yc-split-string c "\177"))) 2))
          (cons (car l) (concat (cadr l) (cdr r)))
        (cons (car l) (cdr r))))))
(defun yc-lookup-rH-list (romaji yc-yomi-dic opt)
  (let ((r (yc-lookup-rH-internal romaji yc-yomi-dic opt))
	(c nil)
	(l nil))
    (when r
      (setq c (car r))
      (if (and c (not (string= (cadr (setq l (yc-split-string c "\177"))) "")))
	  (let ((i (yc-lookup-rH-list (concat (cadr l) (cdr r))
				      yc-yomi-dic opt)))
	    (if (or (null (car i))
		    (string= (cadr l)
			     (substring (car i) 0 (length (cadr l)))))
		(cons (cadr l) (cdr r))
	      (cons (concat (car l) (car i)) (cdr i))))
	(cons (car l) (cdr r))))))

;; flag $B$,(B t $B$N;~(B
;; $B%+!<%=%kD>A0$H(Bfence $B=*C<$N(B n $B$rJQ49$7$J$$(B
(defun yc-conv-rH (romaji &optional flag)
  (let ((hiragana nil) (res '(t)))
    (while (and (car res) (stringp romaji) (> (length romaji) 0))
      (if (yc-get-symbol (string-to-char romaji))
	  (setq res (cons (yc-get-symbol (string-to-char romaji))
			  (substring romaji 1)))
	(setq res (yc-lookup-rH romaji yc-yomi-dic flag)))
      (setq hiragana (concat hiragana (car res))
	    romaji (cdr res)))
    (concat hiragana romaji)))

(defun yc-conv-rH-list (romaji &optional flag)
  (let ((r (yc-generate-romaji-list romaji))
	(hlist nil)
	(rlist nil))
    (while (car r)
      (setq hlist (append hlist (list (yc-conv-rH
				       (car r)
				       (not (and flag (numberp flag))))))
	    rlist (append rlist (list (car r)))
	    r (cdr r)))
    (list hlist rlist)))

(defun yc-generate-romaji-list (romaji)
  (let ((hira (yc-conv-rH romaji))
	(rmj romaji)
	(r '(t)) l h)
    (while (and (car r) (stringp romaji) (> (length romaji) 0))
      (if (yc-get-symbol (string-to-char romaji))
	  (setq r (cons (yc-get-symbol (string-to-char romaji))
			(substring romaji 1)))
	(setq r (yc-lookup-rH-list rmj yc-yomi-dic nil)))
      (setq h (substring hira 0 (length (car r))))
      (if (and (not (string= "" h)) ; 2003/12/25
	       (string= h (car r)))
	  (let ((len (- (length romaji) (length (cdr r)))))
	    (when (> len 0)
	      (setq l (append l (list (substring romaji 0 len))))
	      (setq romaji (substring romaji len)))
	    (setq hira (substring hira (length (car r))))))
      (setq rmj (cdr r)))
    (if (and (stringp romaji) (> (length romaji) 0))
	(append l (list romaji))
      l)))

(defun yc-put-symbol (sym idx)
  (let ((lst yc-defsymbol-list)
	(tmp nil)
	(counter 0))
    (while (car lst)
      (setq tmp (cdar lst))
      (if (assq sym tmp)
	  (setcar (nth counter yc-defsymbol-list) idx))
      (setq lst (cdr lst)
	    counter (1+ counter)))))

(defun yc-get-symbol-list-internal (sym)
  (let ((lst yc-defsymbol-list)
	(idx nil)
	(tmp nil)
	(res nil))
    (while (and (null res) (car lst))
      (setq idx (caar lst)
	    tmp (cdar lst))
      (if (assq sym tmp)
	  (setq res (cons idx (cdr (assq sym tmp)))))
      (setq lst (cdr lst)))
    res))

(defun yc-get-symbol (sym)
  (let ((lst (yc-get-symbol-list-internal sym)))
    (if lst
	(nth (car lst) (cdr lst)))))

(defun yc-get-symbol-list (sym)
  (cdr (yc-get-symbol-list-internal sym)))

;;;
;;; contexts
;;;
(defmacro yc-get (arg)
  (list 'cdr (list 'assq
		   (list 'quote (intern (concat "yc-" (symbol-name arg))))
		   'yc-context)))
(defmacro yc-put (arg val)
  (list 'setq 'yc-context
	(list 'cons
	      (list 'cons
		    (list 'quote (intern (concat "yc-" (symbol-name arg))))
		    val)
	      'yc-context)))

;;;
;;; dictionary management
;;;
(defun yc-mnt-or-mkdic (dic)
  (when (not (yc-mount-dictionary yc-mode-mount-dic (yc-get mount) dic))
    (yc-create-dictionary 128 (yc-get mount) dic)
    (yc-mount-dictionary yc-mode-mount-dic (yc-get mount) dic)))
				  
;;;
;;; group-id
;;;
;; (defun yc-group-name ()
;;   (or (and (not (eq system-type 'w32))
;; 	   (yc-group-name-id)
;; 	   (yc-group-name-perl))
;;       "user"))
(defun yc-group-name ()
  (or (and (eq system-type 'w32) "user")
      (and (eq system-type 'windows-nt) "user")
      (yc-group-name-id)
      (yc-group-name-perl)
      "user"))

(defun yc-group-name-exec (cmd &rest lst)
  (let ((buf "yc:*group*"))
    (save-excursion
      (when (get-buffer buf) (kill-buffer buf))
      (when (= 0 (condition-case nil
		     (eval (append (list 'call-process cmd nil 
					 (get-buffer-create buf) nil) lst))
		   (error 1)))
	(prog2
	    (set-buffer buf)
	    (buffer-substring 1 (goto-char (1- (point-max))))
	  (kill-buffer buf))))))

(defun yc-group-name-id ()
  (yc-group-name-exec "id" "-gn"))

(defun yc-group-name-perl ()
  (yc-group-name-exec
   "env" "LC_ALL=C" "perl" "-e" "$get=getgrgid($();print \"$gid\n\""))

;;;
;;; interface close emacs
;;;
;; $B<-=q$N@_Dj$H%m!<%^;z4A;zJQ49%F!<%V%k$N@_Dj$rM-8z$K$9$k(B
;; $B0lMw%b!<%I$K$J$k2s?t$rM-8z$K$9$k(B

;; .canna's functions:
;;   quote setq set equal = > < progn eq cond null not and or + - * / % gc load
;;   list sequence defun defmacro cons car cdr atom let if boundp fboundp
;;   getenv copy-symbol concat use-dictionary set-mode-display set-key
;;   global-set-key unbind-key-function global-unbind-function defmode
;;   defsymbol defselection defmenu initialize-function define-esc-sequence
;;   define-x-keysym

(defvar yc-def-list nil)
(defvar yc-var-list nil)
(defvar yc-val-list nil)
(defvar yc-fun-list nil)
(defvar yc-exp-list nil)

(defvar yc-rc-dic-list nil)
(defvar yc-rc-bushu-dic-list nil)
(defvar yc-rc-user-dic-list nil)

(defun yc-rc-load (files)
  (if (not (listp files)) (setq files (list files)))
  (let (romkana-table stay-after-validate n-henkan-for-ichiran)
    (while (car files)
      (when (and (file-exists-p (expand-file-name (car files)))
		 (file-readable-p (expand-file-name (car files))))
	(setq yc-rc-dic-list nil
	      yc-rc-bushu-dic-list nil
	      yc-rc-user-dic-list nil)
	(let ((buffer (mapconcat
		       'concat
		       (split-string (yc-read-string-from-file (car files))
				     "\\\\C\\-\\\\") "\\C-\\\\"))
	      (expr '(t . 0)))
	  (while (car (setq expr (condition-case nil
				     (read-from-string buffer (cdr expr))
				   (error nil))))
	    (yc-eval-sexp (car expr)))))
      (setq files (cdr files)))
    (if romkana-table
	(setq yc-rH-conv-dic (yc-search-file-first-in-path
			      romkana-table (list "." (getenv "HOME")
						  yc-canna-dic-path))))
    (if stay-after-validate (setq yc-choice-stay stay-after-validate))
    (if n-henkan-for-ichiran (setq yc-select-count (1- n-henkan-for-ichiran)))
    (setq yc-dic-list (or (reverse yc-rc-dic-list) yc-dic-list)
	  yc-bushu-dic-list (or yc-rc-bushu-dic-list yc-bushu-dic-list)
	  yc-user-dic-list (or yc-rc-user-dic-list yc-user-dic-list))
    (yc-var-unintern)))

(defun yc-eval-sexp (sexp)
  (eval (print (yc-sexp-expand t sexp))))

(if (not (fboundp 'char-or-char-int-p))
    (defalias 'char-or-char-int-p 'numberp))
(defun yc-sexp-expand (car-p sexp)
  (cond ((null sexp) nil)
	((and (fboundp 'char-or-char-int-p)
	      (char-or-char-int-p sexp)) sexp) ; for XEmacs
	((numberp sexp) sexp)
	((stringp sexp) sexp)
	((vectorp sexp) sexp)
	((symbolp sexp)
	 (let ((sym (intern-soft (concat "yc-rc-" (symbol-name sexp)))))
	   (cond ((and sym (fboundp sym)) sym)
		 (car-p 'ignore)
		 (t sexp))))
	(t (let* ((res (list (yc-sexp-expand car-p (car sexp))))
		  (lst (cdr sexp)))
	     (cond ((eq (symbol-function (car res)) 'ignore) '(ignore))
		   ((eq (symbol-function (car res)) 'quote) (cons 'quote lst))
		   (t (if (eq (symbol-function (car res)) 'let)
			  (setq res (append res (list (car lst)))
				lst (cdr lst)))
		      (while lst
			(setq res (append
				   res (list (yc-sexp-expand (listp (car lst))
							     (car lst))))
			      lst (cdr lst)))
		      res))))))

(defun yc-search-file-first-in-path (file path)
  (if (file-exists-p file)
      file
    (cond ((not path) nil)
	  ((file-exists-p (concat (file-name-as-directory (car path)) file))
	   (concat (file-name-as-directory (car path)) file))
	  (t (yc-search-file-first-in-path file (cdr path))))))


(defun yc-rc-use-dictionary (&rest dic)
  (while dic
    (cond ((eq (car dic) :bushu)
	   (setq yc-rc-bushu-dic-list (cons (cadr dic) yc-rc-bushu-dic-list)
		 dic (cddr dic)))
	  ;; TODO: autodef feature
	  ((or (eq (car dic) :user)
	       (eq (car dic) :katakana) (eq (car dic) :hiragana))
	   (setq yc-rc-user-dic-list (cons (cadr dic) yc-rc-user-dic-list)
		 dic (cddr dic)))
	  ((eq (car dic) :grammar)
	   (setq yc-rc-dic-list (cons (cadr dic) yc-rc-dic-list)
		 dic (cddr dic)))
	  (t (setq yc-rc-dic-list (cons (car dic) yc-rc-dic-list)
		   dic (cdr dic))))))

(defun yc-rc-boundp (sym)
  (and (memq sym yc-def-list) t))

(defun yc-rc-fboundp (sym)
  (fboundp (intern-soft (concat "yc-rc-" (symbol-name sym)))))

(defmacro yc-rc-setq (&rest lst)
  (let ((pair '(yc-rc-set)))
    (while lst
      (setq pair (cons (list 'quote (car lst)) pair))
      (setq pair (cons (cadr lst) pair))
      (setq lst (cddr lst)))
    (reverse pair)))

(defun yc-rc-set (&rest lst)
  (let (sym)
    (while lst
      (setq sym (car lst)
	    yc-def-list (cons sym yc-def-list))
      (if (boundp sym)
	  (setq yc-var-list (cons sym yc-var-list)
		yc-val-list (cons (symbol-value sym) yc-val-list)))
      (set sym (cadr lst))
      (setq lst (cddr lst)))
    (symbol-value sym)))

; (defmacro yc-rc-defun (fsym arg &rest exp)
;   (let* ((sym (concat "yc-rc-" (symbol-name fsym)))
; 	 (res (intern-soft sym)))
;     (setq sym (intern sym))
;     (setq yc-def-list (cons sym yc-def-list))
;     (if (not res)
; 	(setq yc-fun-list (cons sym yc-fun-list)
; 	      yc-exp-list (cons (symbol-function sym) yc-exp-list)))
;     (append (list 'defun sym arg) exp)))

; (defmacro yc-rc-defmacro (fsym arg &rest exp)
;   (let* ((sym (concat "yc-rc-" (symbol-name fsym)))
; 	 (res (intern-soft sym)))
;     (setq sym (intern sym))
;     (setq yc-def-list (cons sym yc-def-list))
;     (if (not res)
; 	(setq yc-fun-list (cons sym yc-fun-list)
; 	      yc-exp-list (cons (symbol-function sym) yc-exp-list)))
;     (append (list 'defmacro sym arg) exp)))

(defun yc-var-unintern ()
  (while yc-var-list
    (setq yc-def-list (delq (car yc-var-list) yc-def-list))
    (set (car yc-var-list) (car yc-val-list))
    (setq yc-var-list (cdr yc-var-list)
	  yc-val-list (cdr yc-val-list)))
  (while yc-fun-list
    (setq yc-def-list (delq (car yc-fun-list) yc-def-list))
    (fset (car yc-fun-list) (car yc-exp-list))
    (setq yc-fun-list (cdr yc-var-list)
	  yc-exp-list (cdr yc-exp-list)))
  (while yc-def-list
    (unintern (car yc-def-list))
    (setq yc-def-list (cdr yc-def-list))))

;; sames
(let ((sym '(quote equal = > < progn eq cond null not and or + - * / % gc list
		   cons car cdr atom let if boundp fboundp getenv concat)))
  (while sym
    (defalias (intern (concat "yc-rc-" (symbol-name (car sym)))) (car sym))
    (setq sym (cdr sym))))

;; ignores
(let ((sym '(sequence copy-symbol defun defmacro set-mode-display set-key
		      global-set-key unbind-key-function
		      global-unbind-key-function defmode defselection 
		      defmenu initialize-function define-esc-sequence
		      define-x-keysym)))
  (while sym
    (defalias (intern (concat "yc-rc-" (symbol-name (car sym)))) 'ignore)
    (setq sym (cdr sym))))

(defun yc-rc-defsymbol-internal (lst sym str)
  (if sym
      (cond ((= (length lst) 0)
	     (setq lst (list 0 (cons sym str))))
	    ((/= (length lst) 0)
	     (setcdr (nthcdr (1- (length lst)) lst) (list (cons sym str))))))
  lst)

(defun yc-rc-defsymbol (&rest args)
  (let ((sym nil)
	(str nil)
	(lst nil))
    (while (car args)
      (cond ((integerp (car args))
	     (setq lst (yc-rc-defsymbol-internal lst sym str))
	     (setq sym (car args))
	     (setq str nil))
	    ((stringp (car args))
	     (setq str (append str (list (car args))))))
      (setq args (cdr args)))
    (if yc-defsymbol-list
	(setq yc-defsymbol-list (cons (yc-rc-defsymbol-internal lst sym str)
				      yc-defsymbol-list))
      (setq yc-defsymbol-list (list (yc-rc-defsymbol-internal lst sym str))))
    yc-defsymbol-list))


;; $B=i4|2=4X?t(B
(defun yc-open ()
  (yc-setup)
  (yc-init))

(defun yc-reopen ()
  (when (and yc-server
	     (or (eq (process-status yc-server) 'open)
		 (eq (process-status yc-server) 'run)))
    (yc-close))
  (yc-init))

; (defun yc-setup ()
;   (let ((rc (expand-file-name "~/.ycrc.elc")))
;     (if (or (not (file-exists-p rc))
; 	    (file-newer-than-file-p (concat (get-yc-canna-lib-path)
; 					    "default.canna") rc)
; 	    (file-newer-than-file-p "~/.canna" rc)
; 	    (file-newer-than-file-p "~/.emacs" rc))
; ;	    (file-newer-than-file-p load-file-name rc))
; 	(progn
; 	  (yc-setup-internal)
; 	  (yc-set-skip-chars yc-stop-chars)
; 	  (let ((buf (get-buffer-create ".ycrc.el")))
; 	    (set-buffer buf)
; 	    (delete-region (point-min) (point-max))
; 	    (print (list 'setq 'yc-user-dic-list
; 			 (list 'quote yc-user-dic-list)) buf)
; 	    (print (list 'setq 'yc-bushu-dic-list
; 			 (list 'quote yc-bushu-dic-list)) buf)
; 	    (print (list 'setq 'yc-dic-list (list 'quote yc-dic-list)) buf)
; 	    (print (list 'setq 'yc-defsymbol-list
; 			 (list 'quote yc-defsymbol-list)) buf)
; 	    (print (list 'setq 'yc-yomi-dic (list 'quote yc-yomi-dic)) buf)
; 	    (print (list 'setq 'yc-skip-chars (list 'quote yc-skip-chars)) buf)
; ;	    (require 'bytecomp)
; ;	    (byte-compile-from-buffer buf (expand-file-name rc))
; 	    (write-file "~/.ycrc.el" t)
; 	    (byte-compile-file "~/.ycrc.el")
; 	    (delete-file "~/.ycrc.el")))
;       (load rc))))

; (defun yc-setup-internal ()
;   ;; setup romaji henkan table
;   (yc-rc-load
;    (list (concat (get-yc-canna-lib-path) "default.canna")
; 	 "~/.canna"))
;   (when (stringp yc-rH-conv-dic) (yc-rH-convert-dictionary yc-rH-conv-dic))
;   (when (null yc-rH-table) (setq yc-rH-table yc-default-rH-table))
;   (setq yc-yomi-dic (yc-rH-make-lookup-table yc-rH-table))
;   (yc-Hr-table-setup)
; ;  (yc-rH-table-setup)
;   )

(defun yc-setup-p ()
  (get 'yc-setup 'setup))
(defun yc-setup ()
  ;; setup romaji henkan table
  (unless (yc-setup-p)
    (yc-rc-load
     (if (file-exists-p "~/.canna")
	 `("~/.canna")
     (list (concat (get-yc-canna-lib-path) "default.canna"))))
    (when (stringp yc-rH-conv-dic) (yc-rH-convert-dictionary yc-rH-conv-dic))
    (when (null yc-rH-table) (setq yc-rH-table yc-default-rH-table))
    (setq yc-yomi-dic (yc-rH-make-lookup-table yc-rH-table))
    (yc-Hr-table-setup)
;    (yc-rH-table-setup)
    (put 'yc-setup 'setup t)))

;; cannaserver $B$NDL?.=i4|2=4X?t(B
(defun yc-init-p ()
  (get 'yc-server 'init))
(defun yc-init ()
  (when (and (yc-server-check) (not (yc-init-p)))
    (put 'yc-server 'init t)
    (yc-debug (list yc-server-host yc-canna-lib-path yc-canna-dic-path))
    (yc-put init (yc-initialize 3 3 (user-real-login-name)))
    (yc-notice-group-name 0 (yc-get init) (yc-group-name))

    ;; setup dictionary
    (yc-put mount (yc-create-context))
    (yc-mnt-or-mkdic (car yc-user-dic-list))
    (let ((l (append (cdr yc-user-dic-list) yc-bushu-dic-list yc-dic-list)))
      (while (car l)
	(yc-mount-dictionary yc-mode-mount-dic (yc-get mount) (car l))
	(setq l (cdr l))))

    ;; setup cannaserver part2
    (yc-set-application-name 0 (yc-get mount)
			     (format "Emacs %s" emacs-version))
    (yc-put conv (yc-duplicate-context (yc-get mount)))))

;; $B=*N;;~4X?t(B
(defun yc-close ()
  (when yc-context
    ;; deleted follow line 01/12/29 by matz@ruby-lang.org
;    (set-process-sentinel yc-server nil)
    (condition-case nil
	(yc-finalize)
      (yc-trap-server-down nil))
    (setq yc-context nil)
    (yc-server-close)))

(add-hook 'kill-emacs-hook 'yc-close)


;;;
;;; yc basic operation
;;;

;;; yc basic output
(defvar yc-fence-yomi nil)		; $BJQ49FI$_(B
(defvar yc-fence-start nil)		; fence $B;OC<0LCV(B
(defvar yc-fence-end nil)		; fence $B=*C<0LCV(B
(defvar yc-henkan-separeter " ")	; fence mode separeter
(defvar yc-henkan-buffer nil)		; $BI=<(MQ%P%C%U%!(B
(defvar yc-henkan-length nil)		; $BI=<(MQ%P%C%U%!D9(B
(defvar yc-henkan-revpos nil)		; $BJ8@a;OC<0LCV(B
(defvar yc-henkan-revlen nil)		; $BJ8@aD9(B

;;; yc basic local
(defvar yc-mark nil)			; $BJ8@aHV9f(B
(defvar yc-mark-list nil)		; $BJ8@a8uJdHV9f(B 
(defvar yc-mark-max nil)		; $BJ8@a8uJd?t(B
(defvar yc-henkan-list nil)		; $BJ8@a%j%9%H(B
(defvar yc-kouho-list nil)		; $BJ8@a8uJd%j%9%H(B
(defvar yc-repeat 0)			; $B7+$jJV$72s?t(B

;;
(defvar yc-selected-window nil)		; minibuffer$BB`HrMQ%j%9%H(B
(defvar yc-select-markers nil)		; minibuffer$B8uJd%j%9%H(Bmarkers

(defvar yc-bunsetsu-yomi-list nil)

;; $B;XDjJ8@a$NFI$_$rJV$94X?t(B
;; force $B$,(B $BHs(Bnil $B$N>l9g!"6/@)E*$K(B cannaserver $B$+$iFI$_$r<hF@$9$k(B
;; $BFI$_$r<hF@$7$?J8@a$O$=$NFI$_$r%-%c%C%7%e$9$k(B
(defun yc-get-bunsetsu-yomi (idx &optional force)
  (or (and (not force)
	   (nth idx yc-bunsetsu-yomi-list))
      (yc-get-yomi (yc-get conv) idx 4096)))

;; $B;XDjJ8@a$NFI$_$r@_Dj$9$k4X?t(B
;; cut $B$,(B $BHs(Bnil $B$N>l9g!";XDjJ8@a0J9_$NFI$_$r:o=|$9$k(B
(defun yc-put-bunsetsu-yomi (idx yomi &optional cut)
  (let ((lst (make-list (1+ idx) nil))
	(len (length yc-bunsetsu-yomi-list)))
    (if (null cut)
	(setcdr (nthcdr idx lst) (nthcdr (1+ idx) yc-bunsetsu-yomi-list)))
    (if (<= len 0)
	(setq yc-bunsetsu-yomi-list lst)
      (setcdr (nthcdr (1- len) yc-bunsetsu-yomi-list) (nthcdr len lst)))
    (if cut
	(setcdr (nthcdr idx yc-bunsetsu-yomi-list) nil))
    (setcar (nthcdr idx yc-bunsetsu-yomi-list) yomi))
  yomi)

;; $B;XDjJ8@a$NFI$_$rJV$94X?t(B
;; $BJ8@a$r;XDj$7$J$$>l9g!"8=:_$NJ8@a$,BP>]$H$J$k(B
;; $BFI$_$r<hF@$7$?J8@a$O$=$NFI$_$r%-%c%C%7%e$9$k(B
;; cut $B$,(B $BHs(Bnil $B$N>l9g!";XDjJ8@a0J9_$NFI$_$r:o=|$9$k(B
(defun yc-yomi (&optional idx &optional cut)
  (if (integerp idx)
      (yc-put-bunsetsu-yomi idx (yc-get-bunsetsu-yomi idx cut) cut)
    (yc-put-bunsetsu-yomi yc-mark (yc-get-bunsetsu-yomi yc-mark cut) cut)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo $B>pJs$N@)8f(B $B$H(B yc $B$GL$Dj5A$J%-!<$N%A%'%C%/%"%&%H(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; yc-henkan-mode & yc-select-mode $B%-!<%P%$%s%I(B
;; command $B<B9TA0$K(B command $B$r%A%'%C%/$7$F(B
;; yc $B$GDj5A$7$F$$$J$$(B command $B$r<B9T$7$h$&$H$7$?$i(B
;; $BJQ49$r3NDj$9$k$h$&$K$9$k(B
(defun yc-pre-command-function ()
  (when (and (or yc-henkan-mode yc-edit-mode)
	     (not (string-match "^yc-" (symbol-name this-command))))
    (if yc-edit-mode
	(yc-edit-kakutei)
      (when yc-select-mode (yc-choice))
      (yc-kakutei))))

;; undo buffer $BB`HrMQJQ?t(B
(defvar yc-buffer-undo-list nil)
(make-variable-buffer-local 'yc-buffer-undo-list)
(defvar yc-buffer-modified-p nil)
(make-variable-buffer-local 'yc-buffer-modified-p)

(defvar yc-blink-cursor nil)
(defvar yc-cursor-type nil)
;; undo buffer $B$rB`Hr$7!"(Bundo $B>pJs$NC_@Q$rDd;_$9$k4X?t(B
(defun yc-disable-undo ()
  (when (not (eq buffer-undo-list t))
    (add-hook 'pre-command-hook 'yc-pre-command-function)
    (setq yc-buffer-undo-list buffer-undo-list)
    (setq yc-buffer-modified-p (buffer-modified-p))
    (setq buffer-undo-list t)
    (when (fboundp 'blink-cursor-mode)
      (setq yc-blink-cursor blink-cursor-mode)
      (blink-cursor-mode -1))
    (when (boundp 'cursor-type)
      (setq yc-cursor-type cursor-type)
      (setq cursor-type 1))))

;; $BB`Hr$7$?(B undo buffer $B$rI|5"$7!"(Bundo $B>pJs$NC_@Q$r:F3+$9$k4X?t(B
(defun yc-enable-undo ()
  (remove-hook 'pre-command-hook 'yc-pre-command-function)
  (when (not yc-buffer-modified-p) (set-buffer-modified-p nil))
  (setq buffer-undo-list yc-buffer-undo-list)
  (when (fboundp 'blink-cursor-mode)
    (blink-cursor-mode (if yc-blink-cursor 1 -1)))
  (when (boundp 'cursor-type) (setq cursor-type yc-cursor-type)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $BI=<(7O4X?t72(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar yc-use-fence t)
(defvar yc-use-color nil)
;;           terminal X11
;; xemacs    OK       OK
;; emacs-20  NG       OK
;; emacs-21  OK       OK
(defun yc-use-color ()
  (and yc-use-color
       (or (featurep 'xemacs)
	   (>= emacs-major-version 21)
	   (eq window-system 'x)
	   (eq window-system 'w32))))

(defun yc-frame-parameter (frame prop)
  (if (featurep 'xemacs)
      (let ((value (frame-property frame prop)))
	(cond ((color-instance-p value) (color-instance-name value))
	      (t value)))
    (frame-parameter frame prop)))

(defun yc-selected-frame-parameter (prop)
  (yc-frame-parameter (selected-frame) prop))

(defun yc-move-overlay (overlay beg end &optional buffer)
  (funcall (if (or (not (featurep 'xemacs)) (featurep 'overlay))
	       'move-overlay
	     '(lambda (overlay beg end buffer)
		(detach-extent overlay)
		(insert-extent overlay beg end buffer)))
	   overlay beg end buffer))

(defun yc-overlay-put (overlay prop value)
  (funcall (if (or (not (featurep 'xemacs)) (featurep 'overlay))
	       'overlay-put 'set-extent-property)
	   overlay prop value))

(defmacro yc-delete-overlay (overlay0)
  (list 'when overlay0
	(list 'progn
	      (if (or (not (featurep 'xemacs)) (featurep 'overlay))
		  (list 'delete-overlay overlay0)
		(list 'delete-extent overlay0))
	      (list 'setq overlay0 nil))))

(defun yc-overlayp (overlay)
  (funcall (if (or (not (featurep 'xemacs)) (featurep 'overlay))
	       'overlayp 'extentp) overlay))

(defun yc-make-overlay (beg end &optional buffer)
  (funcall (if (or (not (featurep 'xemacs)) (featurep 'overlay))
	       'make-overlay 'make-extent) beg end buffer))

(defvar yc-fence-face nil)
(defvar yc-current-face nil)

(defvar yc-fence nil)
(defvar yc-current nil)
(defvar yc-select-current nil)

(make-variable-buffer-local 'yc-fence)
(make-variable-buffer-local 'yc-current)
(make-variable-buffer-local 'yc-select-current)

;; (if (or (eq window-system 'x) (eq window-system 'w32))
;;     (progn
;;       (make-face 'yc-fence-face)
;;       (set-face-foreground
;;        'yc-fence-face
;;        (if (eq (yc-selected-frame-parameter 'background-mode) 'dark)
;; 	   "#80FFFF" "#0000FF"))
;;       (make-face 'yc-current-face)
;;       (set-face-foreground 'yc-current-face
;; 			   (or (yc-selected-frame-parameter 'background-color)
;; 			       (face-background 'default)))
;;       (set-face-background 'yc-current-face
;; 			   (yc-selected-frame-parameter 'cursor-color)))
;;   (copy-face 'bold 'yc-fence-face)
;;   (set-face-foreground 'yc-fence-face "blue")
;;   (copy-face 'default 'yc-current-face)
;;   (set-face-foreground 'yc-current-face "red")
;;   (funcall (if (featurep 'xemacs) 'set-face-highlight-p 'set-face-bold-p)
;; 	   'yc-current-face nil))
(defface yc-fence-face
  '((((class color) (background light)) (:foreground "#0000FF"))
    (((class color) (background dark)) (:foreground "#80FFFF"))
    (t (:bold t :foreground "blue")))
  "Face for YC fence."
  :group 'yc)
(defface yc-current-face
  (cond ((featurep 'xemacs)
	 (list (list 't (list :background (face-background-name 'text-cursor)
			      :foreground (face-background-name 'default)))))
	((= emacs-major-version 20)
	 (list (list 't (list :background (yc-selected-frame-parameter
					   'cursor-color)
			      :foreground (or (yc-selected-frame-parameter
					       'background-color)
					      (face-background 'default))))))
	(t (list (list 't (list :background (face-background 'cursor)
				:foreground (face-background 'default))))))
  "Face for YC cursor."
  :group 'yc)
;; (defun yc-colorize ()
;;   (if (or (eq window-system 'x) (eq window-system 'w32))
;;       (progn
;; 	(make-face 'yc-fence-face)
;; 	(unless (face-foreground 'yc-fence-face)
;; 	  (set-face-foreground
;; 	   'yc-fence-face
;; 	   (if (eq (yc-selected-frame-parameter 'background-mode) 'dark)
;; 	       "#80FFFF"
;; 	     "#0000FF"))))
;;     (copy-face 'bold 'yc-fence-face)
;;     (set-face-foreground 'yc-fence-face "blue"))
;;   (if (or (eq window-system 'x) (eq window-system 'w32))
;;       (progn
;; 	(make-face 'yc-current-face)
;; 	(set-face-foreground 'yc-current-face
;; 			     (or
;; 			      (yc-selected-frame-parameter 'background-color)
;; 			      (face-background 'default)))
;; 	(set-face-background 'yc-current-face
;; 			     (or
;; 			      (yc-selected-frame-parameter 'cursor-color))))
;;     (copy-face 'default 'yc-current-face)
;;     (set-face-foreground 'yc-current-face "red")
;;     (funcall (if (featurep 'xemacs) 'set-face-highlight-p 'set-face-bold-p)
;; 	     'yc-current-face nil)))

(defmacro yc-set-overlay (overlay start end face &optional priority)
  (list 'if (list 'yc-use-color)
	(list 'if overlay
	      (list 'yc-move-overlay overlay start end)
	      (list 'setq overlay (list 'yc-make-overlay start end))
;	      (list 'unless (list 'facep (list 'quote face)) '(yc-colorize))
	      (list 'yc-overlay-put overlay ''face (list 'quote face))
	      (if priority
		  (list 'yc-overlay-put overlay ''priority priority)))))

(defun yc-skip-elsechar-forward (chars)
  (let ((chs (append chars nil)))
    (while (and (not (eolp))
		(not (memq (following-char) chs)))
      (forward-char))
    (point)))

;; fence $B$rI=<($9$k%b!<%I(B
(defvar yc-fence-mode nil)

(defun yc-set-overlay-select ()
  (when (yc-use-color)
    (let ((start (1+ (point)))
	  (end (save-excursion (yc-skip-elsechar-forward " \t\n"))))
      (yc-set-overlay yc-select-current start end yc-current-face))))

(defun yc-set-overlay-fence ()
  (when (yc-use-color)
    (yc-set-overlay yc-fence yc-fence-start yc-fence-end yc-fence-face 100)))

(defun yc-set-overlay-current ()
  (when (yc-use-color)
    (let ((start (+ (if yc-select-mode 0 1)
		    (point)))
	  (end (+ (point) yc-henkan-revlen)))
      (yc-set-overlay yc-current start end yc-current-face 200))))

(defun yc-fence-mode (arg)

  ;; $B0lMw%b!<%I4XO"(B
  (if (not yc-select-mode)
      (yc-delete-overlay yc-select-current)
    (yc-set-overlay-select)
    (select-window (car yc-selected-window)))

  ;; $BJQ49%b!<%I$HF~NO%b!<%I4XO"(B
  (when (or yc-fence-mode yc-henkan-mode)
    (when (not (eq yc-fence-start yc-fence-end))
      (delete-region yc-fence-start yc-fence-end))
    (goto-char yc-fence-start))

  ;; fence$B$N@ZBX$((B
  (if (setq yc-fence-mode arg)
      (yc-disable-undo)
    (yc-enable-undo)
    (yc-delete-overlay yc-fence)
    (yc-delete-overlay yc-current))

  ;; fence$B$NI=<((B
  (when yc-fence-mode

    ;; $BJQ49(B/$BJT=8J8;zNs$rA^F~(B
    (when yc-use-fence
      (insert "||")
      (set-marker yc-fence-end (point))
      (backward-char))
    (insert yc-henkan-buffer)
    (unless yc-use-fence
      (set-marker yc-fence-end (point)))

    ;; fence $B$K?'$rIU$1$k(B
    (yc-set-overlay-fence)
    (goto-char (+ (if yc-use-fence 1 0)
		  yc-fence-start
		  (if yc-henkan-mode yc-henkan-revpos (yc-yomi-point))))
    (when yc-henkan-mode
      (yc-set-overlay-current))
;    (goto-char (1- (point)))
;    (print last-command-event)	; DEBUG
    (when yc-select-mode (select-window (minibuffer-window)))))

;; yc $B$N4X?t74$+$i8F$S=P$5$lI=<($r;J$k4X?t(B
(defun yc-post-command-function ()
  (setq yc-henkan-separeter (if yc-use-fence " " ""))
  (when yc-kouho-list
    (setcar (nthcdr yc-mark yc-henkan-list)
	    (nth (nth yc-mark yc-mark-list) yc-kouho-list)))
  (setq yc-henkan-buffer (mapconcat 'concat yc-henkan-list yc-henkan-separeter)
	yc-henkan-length (length yc-henkan-buffer)
	yc-henkan-revpos (+ (if (= yc-mark 0) 0 (length yc-henkan-separeter))
			    (length
			     (mapconcat
			      'concat
			      (nthcdr (- (length yc-henkan-list) yc-mark)
				      (reverse yc-henkan-list))
			      yc-henkan-separeter)))
	yc-henkan-revlen (length (nth yc-mark yc-henkan-list)))

  (if (not yc-select-mode)
      (yc-fence-mode t)
    (goto-char (nth (nth yc-mark yc-mark-list) yc-select-markers))
    (yc-fence-mode t) ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $BEPO?%b!<%I(B & $B0lMw%b!<%I6&DL4X?t(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar yc-select-buffer " yc-select")
(defvar yc-select-markers nil)

(defun yc-make-select-buffer (lst)
  (setq yc-selected-window (cons (selected-window) yc-selected-window))
  (unless (featurep 'xemacs)
    (set-minibuffer-window (minibuffer-window)))
  (yc-redirect-frame-focus
   (window-frame (car yc-selected-window))
   (window-frame (select-window (minibuffer-window))))
  (raise-frame (window-frame (select-window (minibuffer-window))))
  (set-window-buffer (minibuffer-window) (get-buffer-create yc-select-buffer))
  (let ((l lst))
    (while l
      (setq yc-select-markers (cons (point-marker) yc-select-markers))
      (insert (car l) " ")
      (setq l (cdr l))))
  (setq yc-select-markers (reverse yc-select-markers))
  (let ((fill-column (- (window-width (minibuffer-window)) 2)))
    (fill-region 1 (point-max))
    (message nil))
  (let ((l yc-select-markers))
    (while l
      (goto-char (car l))
      (when (and (not (eobp)) (eolp)) (set-marker (car l) (1+ (car l))))
      (setq l (cdr l)))))

(defun yc-delete-select-buffer ()
  (let ((l yc-select-markers))
    (while l
      (set-marker (car l) nil)
      (setq l (cdr l))))
  (setq yc-select-markers nil)
  (when yc-select-current (yc-delete-overlay yc-select-current))
  (delete-region 1 (point-max))
  (set-window-buffer (minibuffer-window)
		     (get-buffer (format " *Minibuf-%d*"
					 (minibuffer-depth))))
  (yc-redirect-frame-focus (window-frame (car yc-selected-window)) nil)
  (message "")
  (raise-frame (window-frame (select-window (car yc-selected-window))))
  (setq yc-selected-window (cdr yc-selected-window)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $B5-9fA*Br%b!<%I(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $B5-9fA*Br%b!<%I$OC`0l$K0lMw%j%9%H$r@8@.$9$k(B
;; $B5-9f$N0lMw%b!<%I$r@EE*$K;}$D$N$O6u4V$NL5BL$@$7(B
;; $B5-9f$N0lMwI=$r:n$k$N$O;~4V$NL5BL$@$+$i(B
(define-key yc-wclist-mode-map "\C-p" 'yc-wclist-prev-line)
(define-key yc-wclist-mode-map "\C-n" 'yc-wclist-next-line)
(define-key yc-wclist-mode-map "\C-b" 'yc-wclist-prev-wchar)
(define-key yc-wclist-mode-map "\C-f" 'yc-wclist-next-wchar)
(define-key yc-wclist-mode-map " "    'yc-wclist-next-wchar)
(define-key yc-wclist-mode-map "\C-a" 'yc-wclist-beginning-of-line)
(define-key yc-wclist-mode-map "\C-e" 'yc-wclist-end-of-line)
(define-key yc-wclist-mode-map "\C-m" 'yc-wclist-choice)
(define-key yc-wclist-mode-map "\C-q" 'yc-wclist-choice-continue)
(define-key yc-wclist-mode-map "\C-g" 'yc-wclist-cancel)
(define-key yc-wclist-mode-map [up] 'yc-wclist-prev-line)
(define-key yc-wclist-mode-map [down] 'yc-wclist-next-line)
(define-key yc-wclist-mode-map [left] 'yc-wclist-prev-wchar)
(define-key yc-wclist-mode-map [right] 'yc-wclist-next-wchar)

;; $B5-9fA*Br%b!<%I;~$N%3%^%s%I%A%'%C%/4X?t(B
;; $B5-9f%b!<%IMQ$KDj5A$7$?%3%^%s%I0J30$N%3%^%s%I$,(B
;; $BF~NO$5$l$?>l9g$K$O5-9fA*Br%b!<%I$rH4$1$F(B
;; $BF~NO$5$l$?%3%^%s%I$r<B9T$9$k(B
(defun yc-wclist-pre-command-function ()
  (when (not (string-match "^yc-wclist-" (symbol-name this-command)))
    (yc-wclist-cancel)))

(defvar yc-wclist-buf " yc-wclist")

(defvar yc-wclist-pos 0)
(defvar yc-wclist-orow -1)
(defvar yc-wclist-lst nil)
(defconst yc-wclist-min ?\xA1)
(defconst yc-wclist-max ?\xFE)
(defconst yc-wclist-len (- yc-wclist-max yc-wclist-min))

(defun yc-wclist-mode (&optional arg)
  (interactive "P")
  (setq yc-wclist-mode (if (null arg) (not yc-wclist-mode)
			 (> (prefix-numeric-value arg) 0)))
  (force-mode-line-update t)
  (if yc-wclist-mode
      (progn
	(setq yc-selected-window (cons (selected-window) yc-selected-window))
	(unless (featurep 'xemacs)
	  (set-minibuffer-window (minibuffer-window)))
	(yc-redirect-frame-focus
	 (window-frame (car yc-selected-window))
	 (window-frame (select-window (minibuffer-window))))
	(raise-frame (window-frame (select-window (minibuffer-window))))
	(set-window-buffer (minibuffer-window)
			   (get-buffer-create yc-wclist-buf))
	(add-hook 'pre-command-hook 'yc-wclist-pre-command-function)
	(setq yc-wclist-orow -1)
	(yc-wclist-display))
    (remove-hook 'pre-command-hook 'yc-wclist-pre-command-function)
    (delete-region (point-min) (point-max))
    (set-window-buffer (minibuffer-window)
		       (get-buffer (format " *Minibuf-%d*"
					   (minibuffer-depth))))
    (yc-redirect-frame-focus (window-frame
			      (select-window (car yc-selected-window))) nil)
    (setq yc-selected-window (cdr yc-selected-window))))

(defun yc-wclist-create-list (lines)
  (let ((gap (/ (window-width (minibuffer-window)) 3))
	(len (- ?\xFE ?\xA1))
	lst tmp row col
	(idx 0))
    (while (< idx gap)
      (setq tmp (% (+ idx (* lines gap)) (* len len)))
      (setq row (car (yc-wclist-liner-to-code tmp)))
      (setq col (cdr (yc-wclist-liner-to-code tmp)))
      (setq lst (cons
		 (decode-coding-string
		  (concat (char-to-string row) (char-to-string col)) 'euc-jp)
		 lst))
      (setq idx (1+ idx)))
    (reverse lst)))

(defun yc-wclist-add (val oft)
  (let ((gap (* (- ?\xFE ?\xA1) (- ?\xFE ?\xA1))))
    (setq val (+ val oft))
    (while (< val 0)
      (setq val (+ val gap)))
    (% val gap)))
(defun yc-wclist-sub (val oft)
  (yc-wclist-add val (- oft)))

(defun yc-wclist-code-to-liner (hgh low)
  (+ (* (- hgh ?\xA1) (- ?\xFE ?\xA1)) (- low ?\xA1)))
(defun yc-wclist-liner-to-code (val)
  (cons (+ (/ val (- ?\xFE ?\xA1)) ?\xA1)
	(+ (% val (- ?\xFE ?\xA1)) ?\xA1)))
(defun yc-wclist-disp-to-liner (row col)
  (+ (* row (/ (window-width (minibuffer-window)) 3)) col))
(defun yc-wclist-liner-to-disp (val)
  (cons (/ val (/ (window-width (minibuffer-window)) 3))
	(% val (/ (window-width (minibuffer-window)) 3))))
(defun yc-wclist-disp-to-code (row col)
  (yc-wclist-liner-to-code (yc-wclist-disp-to-liner row col)))
(defun yc-wclist-code-to-disp (hgh low)
  (yc-wclist-liner-to-disp (yc-wclist-code-to-liner hgh low)))

(defun yc-wclist-display ()
  (when (/= (car (yc-wclist-liner-to-disp yc-wclist-pos)) yc-wclist-orow)
    (setq yc-wclist-lst (yc-wclist-create-list
			 (setq yc-wclist-orow (car (yc-wclist-liner-to-disp
						    yc-wclist-pos)))))
    (delete-region (point-min) (point-max))
    (insert (mapconcat 'concat yc-wclist-lst " ")))
  (goto-char (1+ (* (cdr (yc-wclist-liner-to-disp yc-wclist-pos)) 2))))

(defun yc-wclist-end-of-line ()
  (interactive)
  (setq yc-wclist-pos (yc-wclist-disp-to-liner
		       (car (yc-wclist-liner-to-disp yc-wclist-pos))
		       (1- (/ (window-width (minibuffer-window)) 3))))
  (yc-wclist-display))

(defun yc-wclist-beginning-of-line ()
  (interactive)
  (setq yc-wclist-pos (yc-wclist-disp-to-liner
		       (car (yc-wclist-liner-to-disp yc-wclist-pos)) 0))
  (yc-wclist-display))

(defun yc-wclist-next-wchar ()
  (interactive)
  (setq yc-wclist-pos (yc-wclist-add yc-wclist-pos 1))
  (yc-wclist-display))

(defun yc-wclist-prev-wchar ()
  (interactive)
  (setq yc-wclist-pos (yc-wclist-sub yc-wclist-pos 1))
  (yc-wclist-display))

(defun yc-wclist-next-line ()
  (interactive)
  (setq yc-wclist-pos (yc-wclist-add yc-wclist-pos
				     (/ (window-width (minibuffer-window)) 3)))
  (yc-wclist-display))

(defun yc-wclist-prev-line ()
  (interactive)
  (setq yc-wclist-pos (yc-wclist-sub yc-wclist-pos
				     (/ (window-width (minibuffer-window)) 3)))
  (yc-wclist-display))

(defun yc-wclist-choice ()
  (interactive)
  (yc-wclist-choice-continue)
  (yc-wclist-mode -1))

(defun yc-wclist-choice-continue ()
  (interactive)
  (select-window (car yc-selected-window))
  (insert (nth (cdr (yc-wclist-liner-to-disp yc-wclist-pos)) yc-wclist-lst))
  (select-window (minibuffer-window)))

(defun yc-wclist-cancel ()
  (interactive)
  (yc-wclist-mode -1))

(defun yc-wclist-cancel-self-insert (arg)
  (interactive "p")
  (setq unread-command-events (list last-command-event))
  (yc-wclist-mode -1))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $BEPO?%b!<%I(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(let ((i 0))
  (while (< i ?\177)
    (define-key yc-defword-mode-map (char-to-string i)
      'yc-defword-cancel-and-self-insert)
    (setq i (1+ i))))
(define-key yc-defword-mode-map "\C-m" 'yc-defword)
(define-key yc-defword-mode-map "\C-g" 'yc-defword-cancel)
(define-key yc-defword-mode-map "\C-a" 'yc-defword-beginning-of-line)
(define-key yc-defword-mode-map "\C-e" 'yc-defword-end-of-line)
(define-key yc-defword-mode-map "\C-f" 'yc-defword-forward)
(define-key yc-defword-mode-map " "    'yc-defword-forward)
(define-key yc-defword-mode-map "\C-b" 'yc-defword-backward)
(define-key yc-defword-mode-map "\C-n" 'yc-defword-beginning-of-line)
(define-key yc-defword-mode-map "\C-p" 'yc-defword-end-of-line)
(define-key yc-defword-mode-map [up] 'yc-defword-end-of-line)
(define-key yc-defword-mode-map [down] 'yc-defword-beginning-of-line)
(define-key yc-defword-mode-map [right] 'yc-defword-forward)
(define-key yc-defword-mode-map [left] 'yc-defword-backward)

;;; $BEPO?MQJQ?t(B
;; Canna v3.5
;; $BL>;l(B[#T35]		$B$9$k(B[#T30]$B!"$J(B[#T15]$B!"$9$k(B&$B$J(B[#T10]
;; $B8GM-L>;l(B[#KK]	$B?ML>(B[#JN]$B!"COL>(B[#CN]$B!"?ML>(B&$BCOL>(B[#JCN]
;; $BF0;l(B[#G5]		$B$$(B($BL>;l(B)[#G5r]... $BB>$K$b$$$m$$$m$"$k(B main.code
;;                      $BF0;l$O=*;_7A(B($B$&CJ$G=*$k$O$:(B)$B$N$_EPO?2DG=$H$7(B
;;                      $B:G8e$N0lJ8;z$G3hMQ9T(B($B!V$"9T!W$H$+!V$+9T!W(B)$B$rH=CG$9$k(B
;; $B7AMF;l(B[#KT]		($BL>;l(B)[#KTY]
;; $B7AMFF0;l(B[#T18]	$B$9$k(B[#T13]$B!"(B($BL>;l(B)[#T15]$B!"$9$k(B&($BL>;l(B)[#T10]
;; $BI{;l(B[#F14]		$B$9$k(B[#F12]$B!"$H(B[#F06]$B!"$9$k(B&$B$H(B[#F04]
;; $B$=$NB>(B[#KJ]
(defvar yc-defword-mark nil)
(defvar yc-defword-yomi nil)
(defvar yc-defword-word nil)
(defvar yc-hinshi-list
  '("$B?ML>(B" "$BCOL>(B" "$B?ML>(B&$BCOL>(B" "$B8GM-L>;l(B" "$BL>;l(B" "$B$=$NB>(B"))
(defvar yc-hinshi-item
  '(("$B?ML>(B" . "#JN") ("$BCOL>(B" . "#CN") ("$B?ML>(B&$BCOL>(B" . "#JCN")
    ("$B8GM-L>;l(B" . "#KK") ("$BL>;l(B" . "#T35") ("$B$5JQL>;l(B" . "#T30")
    ("$B7AMF;l3hMQL>;l(B" . "#T15") ("$B$5JQ(B&$B7AMF;l3hMQL>;l(B" . "#T10")
    ("$B$=$NB>(B" . "#KJ")))

;; $BEPO?;~$NA*BrIJ;l8uJd$r(B minibuffer $B$KI=<($9$kMQ0U$r$9$k4X?t(B
(defun yc-make-touroku-buffer ()
  (setq yc-defword-mode t
	yc-defword-mark 0)
  (yc-make-select-buffer yc-hinshi-list)
  (goto-char (nth yc-defword-mark yc-select-markers)))

(defun yc-color-touroku ()
  (when (yc-use-color)
    (let ((start (1+ (point)))
	  (end (save-excursion (yc-skip-elsechar-forward " \t\n"))))
      (yc-set-overlay yc-select-current start end yc-current-face))))

;; $BC18l$r<B:]$KEPO?$9$k4X?t(B
(defun yc-defword ()
  (interactive)
  (yc-define-word (yc-get conv)
		  (concat yc-defword-yomi " "
			  (cdr (assoc (nth yc-defword-mark yc-hinshi-list)
				      yc-hinshi-item))
			  " " yc-defword-word) (car yc-user-dic-list))
  (yc-mount-dictionary yc-mode-mount-dic (yc-get mount) (car yc-user-dic-list))

  (when (yc-overlayp yc-select-current) (yc-delete-overlay yc-select-current))
  (setq yc-defword-mode nil)
  (yc-delete-select-buffer))

;; $B%j!<%8%g%s$NC18l$r<-=q$KEPO?$9$k4X?t(B
(defun yc-touroku-region (b e)
  "$B;XDj$5$l$?(B region $B$r<-=qEPO?$9$k(B"
  (interactive "r")
  (setq yc-defword-word (buffer-substring b e))
  (setq yc-defword-yomi
	(read-from-minibuffer (concat "$BC18l(B[" yc-defword-word "] $BFI$_(B? ")
			      nil yc-defword-minibuffer-map))
  (or (string= yc-defword-yomi "")
      (yc-make-touroku-buffer))
  (yc-color-touroku))
  
;; $BIJ;lA*Br;~$K<!8uJd$K0\F0$9$k4X?t(B
(defun yc-defword-forward ()
  "$B<-=qEPO?Cf$NIJ;lA*Br;~$K<!$NIJ;l$K0\F0$9$k(B"
  (interactive)
  (setq yc-defword-mark (1+ yc-defword-mark))
  (when (<= (length yc-select-markers) yc-defword-mark)
    (setq yc-defword-mark 0))
  (goto-char (nth yc-defword-mark yc-select-markers))
  (yc-color-touroku))

;; $BIJ;lA*Br;~$KA08uJd$K0\F0$9$k4X?t(B
(defun yc-defword-backward ()
  "$B<-=qEPO?Cf$NIJ;lA*Br;~$KA0$NIJ;l$K0\F0$9$k(B"
  (interactive)
  (setq yc-defword-mark (1- yc-defword-mark))
  (when (> 0 yc-defword-mark)
    (setq yc-defword-mark (1- (length yc-select-markers))))
  (goto-char (nth yc-defword-mark yc-select-markers))
  (yc-color-touroku))

;; $BIJ;lA*Br;~$K@hF,IJ;l$K0\F0$9$k4X?t(B
(defun yc-defword-beginning-of-line ()
  "$B<-=qEPO?;~$NIJ;lA*Br;~$K@hF,$NIJ;l$K0\F0$9$k(B"
  (interactive)
  (setq yc-defword-mark 0)
  (goto-char (nth yc-defword-mark yc-select-markers))
  (yc-color-touroku))

;; $BIJ;lA*Br;~$K:G=*IJ;l$K0\F0$9$k4X?t(B
(defun yc-defword-end-of-line ()
  "$B<-=qEPO?;~$NIJ;lA*Br;~$K:G=*$NIJ;l$K0\F0$9$k(B"
  (interactive)
  (setq yc-defword-mark (1- (length yc-select-markers)))
  (goto-char (nth yc-defword-mark yc-select-markers))
  (yc-color-touroku))

;; $BEPO?$rCf;_$9$k4X?t(B
(defun yc-defword-cancel ()
  "$B<-=qEPO?$rCf;_$9$k(B"
  (interactive)
  (when (yc-overlayp yc-select-current) (yc-delete-overlay yc-select-current))
  (setq yc-defword-mode nil)
  (yc-delete-select-buffer))
(defun yc-defword-cancel-and-self-insert ()
  (interactive)
  (yc-defword-cancel)
  (setq unread-command-events (list last-command-event)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $B0lMw%b!<%I(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(let ((i 0))
  (while (<= i ?\177)
    (define-key yc-select-mode-map (char-to-string i)
      'yc-choice-and-self-insert)
    (setq i (1+ i))))
(define-key yc-select-mode-map "\C-m" 'yc-choice)
(define-key yc-select-mode-map "\C-g" 'yc-select-cancel)
(define-key yc-select-mode-map "\C-a" 'yc-select-beginning-of-line)
(define-key yc-select-mode-map "\C-e" 'yc-select-end-of-line)
(define-key yc-select-mode-map "\C-f" 'yc-select-forward)
(define-key yc-select-mode-map "\C-b" 'yc-select-backward)
(define-key yc-select-mode-map "\C-n" 'yc-select-next)
(define-key yc-select-mode-map "\C-p" 'yc-select-previous)
(define-key yc-select-mode-map yc-rK-trans-key 'yc-modeless-next)
(define-key yc-select-mode-map " "    'yc-modeless-next)
(define-key yc-select-mode-map "\C-i" 'yc-select-tidime)
(define-key yc-select-mode-map "\C-o" 'yc-select-nobasi)
(define-key yc-select-mode-map "\C-t" 'yc-choice-and-touroku)
(define-key yc-select-mode-map "\177" 'yc-hiragana)
(define-key yc-select-mode-map [backspace] 'yc-hiragana)
(define-key yc-select-mode-map "\C-k" 'yc-katakana)
(define-key yc-select-mode-map "\C-u" 'yc-alphabet2)
(define-key yc-select-mode-map "\C-l" 'yc-alphabet)
(define-key yc-select-mode-map [up] 'yc-select-previous)
(define-key yc-select-mode-map [down] 'yc-select-next)
(define-key yc-select-mode-map [right] 'yc-select-forward)
(define-key yc-select-mode-map [left] 'yc-select-backward)

;; $B0lMw%b!<%I$r3+;O$9$k4X?t(B
(defun yc-select ()
  (condition-case nil
      (progn
	(unless (window-minibuffer-p (selected-window))
	  (yc-get-kouho-list)
	  (setq yc-select-mode t
		yc-select-markers nil)
	  (yc-make-select-buffer yc-kouho-list))
	(yc-post-command-function))
    (yc-trap-server-down (yc-cancel))))

;; $B0lMw%b!<%I$G<!8uJd$K0\F0$9$k4X?t(B
(defun yc-select-forward ()
  "$B0lMw%b!<%I$G<!$N8uJd$K0\F0$9$k(B"
  (interactive)
  (yc-next-kouho)
  (yc-post-command-function))

;; $B0lMw%b!<%I$GA08uJd$K0\F0$9$k4X?t(B
(defun yc-select-backward ()
  "$B0lMw%b!<%I$GA0$N8uJd$K0\F0$9$k(B"
  (interactive)
  (yc-prev-kouho)
  (yc-post-command-function))

;; $B0lMw%b!<%I$G<!9T$N8uJd$K0\F0$9$k4X?t(B
(defun yc-select-next ()
  "$B0lMw%b!<%I$G<!9T$N8uJd$K0\F0$9$k(B"
  (interactive)
  (yc-next-kouho)
  (goto-char (nth (nth yc-mark yc-mark-list) yc-select-markers))
  (while (not (bolp))
    (yc-next-kouho)
    (goto-char (nth (nth yc-mark yc-mark-list) yc-select-markers)))
  (yc-post-command-function))

;; $B0lMw%b!<%I$GA09T$N8uJd$K0\F0$9$k4X?t(B
(defun yc-select-previous ()
  "$B0lMw%b!<%I$GA09T$N8uJd$K0\F0$9$k(B"
  (interactive)
  (yc-select-beginning-of-line)
  (yc-select-backward)
  (yc-select-beginning-of-line))

;; $B0lMw%b!<%I$G8+$($F$$$k8uJd72$N@hF,$K0\F0$9$k4X?t(B
(defun yc-select-beginning-of-line ()
  "$B0lMw%b!<%I$G9TF,$N8uJd$K0\F0$9$k(B"
  (interactive)
  (while (not (bolp))
    (yc-prev-kouho)
    (goto-char (nth (nth yc-mark yc-mark-list) yc-select-markers)))
  (yc-post-command-function))

;; $B0lMw%b!<%I$G8+$($F$$$k8uJd72$NKvHx$K0\F0$9$k4X?t(B
(defun yc-select-end-of-line ()
  "$B0lMw%b!<%I$G9TKv$N8uJd$K0\F0$9$k(B"
  (interactive)
  (yc-select-next)
  (yc-select-backward))

;; $B0lMw%b!<%I$GJ8@a$r?-$P$94X?t(B
;; $B0lMw%b!<%I$OH4$1$k(B
(defun yc-select-nobasi ()
  "$B0lMw%b!<%I$GBP>]J8@aD9$r?-$P$9!#(B
$BI{:nMQ$H$7$F0lMw%b!<%I$OH4$1$k(B"
  (interactive)
  (yc-select-cancel)
  (setq unread-command-events (list last-command-event)))

;; $B0lMw%b!<%I$GJ8@a$r=L$a$k4X?t(B
;; $B0lMw%b!<%I$OH4$1$k(B
(defun yc-select-tidime ()
  "$B0lMw%b!<%I$GBP>]J8@aD9$r=L$a$k!#(B
$BI{:nMQ$H$7$F0lMw%b!<%I$OH4$1$k(B"
  (interactive)
  (yc-select-cancel)
  (setq unread-command-events (list last-command-event)))

;; $B0lMw%b!<%I$G8uJd$rA*Br$9$kFbIt4X?t(B
(defun yc-choice-internal ()
  (setq yc-select-mode nil)
  (yc-delete-select-buffer))

;; $B0lMw%b!<%I$G8uJd$rA*Br$9$k4X?t(B
;; $BEvA3!"0lMw%b!<%I$OH4$1$k(B
(defun yc-choice ()
  "$B0lMw%b!<%I$G8uJd$rA*Br$9$k!#(B
$B0lMw%b!<%I$OH4$1$k(B"
  (interactive)
  (yc-choice-internal)
  (condition-case nil
      (when (not yc-choice-stay) (yc-forward-bunsetsu))
    (yc-trap-server-down
     (condition-case nil
	 (yc-backward-bunsetsu)
       (yc-trap-server-down nil))
     (setcar (nthcdr yc-mark yc-mark-list) 0)
     (setcar (nthcdr yc-mark yc-henkan-list)
	     (nth (nth yc-mark yc-mark-list) yc-kouho-list))))
  (yc-post-command-function))

;; $B0lMw%b!<%I$G8uJd$rA*Br$7!"$+$D!"JQ49$r3NDj$7F~NO$5$l$?%-!<$r:FF~NO$9$k4X?t(B
;; $B0lMw%b!<%I$*$h$SJQ49%b!<%I$rH4$1$k(B
(defun yc-choice-and-self-insert (arg)
  "$B0lMw%b!<%I$G8uJd$rA*Br$70lMw%b!<%I$rH4$1$?8e$G!"(B
$BJQ49$r3NDj$7!"F~NO$5$l$?J8;z$rF~NO$9$k(B"
  (interactive "P")
  (yc-choice)
  (yc-kakutei)
  (setq unread-command-events (list last-command-event)))

;; $B0lMw%b!<%I$G8uJd$rA*Br$7!"$+$D!"JQ49$r3NDj$7!"(B
;; $B3NDj$7$?J8;zNs$r<-=qEPO?$9$k4X?t(B
;; $B0lMw%b!<%I$*$h$SJQ49%b!<%I$rH4$1$k(B
(defun yc-choice-and-touroku ()
  "$B0lMw%b!<%I$G8uJd$rA*Br$70lMw%b!<%I$rH4$1$?8e$G!"JQ49$r3NDj$9$k(B"
  (interactive)
  (yc-choice)
  (yc-kakutei)
  (yc-touroku-region yc-fence-start yc-fence-end))

;; $B0lMw%b!<%I$rCf;_$9$k4X?t(B
;; $BEvA30lMw%b!<%I$OH4$1$k(B
(defun yc-select-cancel ()
  "$B0lMw%b!<%I$rCf;_$9$k(B"
  (interactive)
  (yc-choice-internal)
  (setcar (nthcdr yc-mark yc-mark-list) 0)
  (setcar (nthcdr yc-mark yc-henkan-list)
	  (nth (nth yc-mark yc-mark-list) yc-kouho-list))
  (yc-post-command-function))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $BFI$_F~NO!uFI$_JT=8%b!<%I(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fence $B%b!<%IMQJQ?t(B
; yc-fence-yomi $B$K%-!<F~NO$7$?%m!<%^;z$r3JG<$7$F$$$k(B 
(defvar yc-hiragana-list nil)
(defvar yc-romaji-list nil)
(defvar yc-yomi-string-point nil)
(defvar yc-yomi-list-point nil)

;; $BFI$_$N@_Dj$r=i4|2=$9$k(B
(defun yc-yomi-reset ()
  (setq yc-fence-yomi ""
	yc-hiragana-list nil
	yc-romaji-list nil
	yc-yomi-string-point 0
	yc-yomi-list-point 0))

;; $BFI$_$rF~NO$9$k(B
(defun yc-yomi-insert (str)
  (let* ((rt (nthcdr yc-yomi-list-point yc-romaji-list))
	 (ht (car (yc-conv-rH-list (apply 'concat rt) t)))
	 (ym (substring yc-fence-yomi 0 (- (length yc-fence-yomi)
					   (length (apply 'concat rt))))))
    (let ((rr (yc-conv-rH-list (concat ym str) 0)))
      (setq yc-yomi-list-point (length (cadr rr)))
      (setq yc-hiragana-list (append (car rr) ht))
      (setq yc-romaji-list (append (cadr rr) rt))
      (setq yc-fence-yomi (apply 'concat yc-romaji-list)))))

(defun yc-yomi-post-insert ()
  (if (and (or (eq last-command 'yc-edit-self-insert)
	       (eq last-command 'yc-input-self-insert))
	   (> yc-yomi-list-point 0)
	   (string= (nth (1- yc-yomi-list-point) yc-hiragana-list)
		    (nth (1- yc-yomi-list-point) yc-romaji-list)))
      (setcar (nthcdr (1- yc-yomi-list-point) yc-hiragana-list)
	      (caar (yc-conv-rH-list (nth (1- yc-yomi-list-point)
					  yc-romaji-list) 0)))))

;; $BFI$_$r:o=|$9$k(B
(defun yc-yomi-delete ()
  (setq yc-romaji-list (yc-generate-romaji-list yc-fence-yomi))
  (if (= yc-yomi-list-point 0)
      (setq yc-romaji-list (cdr yc-romaji-list)
	    yc-hiragana-list (cdr yc-hiragana-list))
    (setcdr (nthcdr (1- yc-yomi-list-point) yc-romaji-list)
	    (nthcdr (1+ yc-yomi-list-point) yc-romaji-list))
    (setcdr (nthcdr (1- yc-yomi-list-point) yc-hiragana-list)
	    (nthcdr (1+ yc-yomi-list-point) yc-hiragana-list)))
  (setq yc-fence-yomi (apply 'concat yc-romaji-list)))

;; $BFI$_$r=*C<$^$G:o=|$9$k(B
(defun yc-yomi-kill ()
  (setq yc-romaji-list (yc-generate-romaji-list yc-fence-yomi))
  (setq yc-romaji-list
	(yc-subsequence yc-romaji-list 0 yc-yomi-list-point)
	yc-hiragana-list
	(yc-subsequence yc-hiragana-list 0 yc-yomi-list-point)
	yc-fence-yomi (apply 'concat yc-romaji-list)))

;; $BA0$NFI$_$K0\F0(B
(defun yc-yomi-prev ()
  (setq yc-yomi-list-point (1- yc-yomi-list-point))
  (if (< yc-yomi-list-point 0)
      (setq yc-yomi-list-point 0)
    (setq yc-yomi-string-point
	  (- yc-yomi-string-point
	     (yc-strlen (nth yc-yomi-list-point yc-romaji-list))))))

;; $B<!$NFI$_$K0\F0(B
(defun yc-yomi-next ()
  (setq yc-yomi-list-point (1+ yc-yomi-list-point))
  (if (> yc-yomi-list-point (length yc-hiragana-list))
      (setq yc-yomi-list-point (length yc-hiragana-list))
    (setq yc-yomi-string-point
	  (+ yc-yomi-string-point
	     (yc-strlen (nth (1- yc-yomi-list-point) yc-romaji-list))))))

;; $B:G=i$NFI$_$K0\F0(B
(defun yc-yomi-bob ()
  (setq yc-yomi-string-point 0
	yc-yomi-list-point 0))

;; $B:G8e$NFI$_$K0\F0(B
(defun yc-yomi-eob ()
  (setq yc-yomi-string-point (length yc-fence-yomi)
;	yc-yomi-list-point (length yc-romaji-list)))
	yc-yomi-list-point (length yc-hiragana-list)))

;; $B$R$i2>L>FI$_J8;zNs$rJV$9(B
(defun yc-yomi-hiragana ()
  (apply 'concat yc-hiragana-list))

;; $B$R$i2>L>FI$_J8;zNs$N%+!<%=%k0LCV$rJV$9(B
(defun yc-yomi-point ()
  (yc-strlen
   (apply 'concat (yc-subsequence yc-hiragana-list 0 yc-yomi-list-point))))

;; $BFI$_JT=8Cf$N%-!<$NF~NO=hM}(B
(defun yc-self-insert-internal ()
  (if (or (eq last-command 'yc-edit-next)
	  (eq last-command 'yc-edit-previous))
      (let ((last-str (char-to-string (event-to-character
				       last-command-event))))
	(yc-fence-mode nil)
	(insert (yc-yomi-hiragana))
	(yc-yomi-reset)
	(setq yc-edit-mode t
	      yc-mark 0
	      yc-fence-yomi ""
	      yc-henkan-list nil
	      yc-fence-start (copy-marker (point-marker))
	      yc-fence-end (copy-marker (point-marker)))))
;	(yc-yomi-insert last-str)
;	(yc-edit-post-command-function)))
  (yc-yomi-insert (char-to-string (event-to-character last-command-event)))
  (yc-edit-post-command-function))

;; $BFI$_JT=8Cf$NI=<(4X?t(B
(defun yc-edit-post-command-function ()
  (setq yc-henkan-list (list (yc-yomi-hiragana)))
;  (prin1 yc-fence-yomi)
;  (prin1 yc-romaji-list)
  (yc-post-command-function))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $B$R$i2>L>JT=8%b!<%I(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(let ((i (1+ ? )))
  (while (< i ?\177)
    (define-key yc-edit-mode-map (char-to-string i) 'yc-edit-self-insert)
    (setq i (1+ i))))
(define-key yc-edit-mode-map "\C-g" 'yc-edit-cancel)
(define-key yc-edit-mode-map "\C-a" 'yc-edit-beginning-of-fence)
(define-key yc-edit-mode-map "\C-e" 'yc-edit-end-of-fence)
(define-key yc-edit-mode-map "\C-b" 'yc-edit-backward-char)
(define-key yc-edit-mode-map "\C-f" 'yc-edit-forward-char)
(define-key yc-edit-mode-map "\177" 'yc-edit-backward-delete-char)
(define-key yc-edit-mode-map [backspace] 'yc-edit-backward-delete-char)
(define-key yc-edit-mode-map "\C-h" 'yc-edit-delete-char)
(define-key yc-edit-mode-map "\C-d" 'yc-edit-delete-char)
(define-key yc-edit-mode-map " "    'yc-edit-henkan)
(define-key yc-edit-mode-map yc-rK-trans-key 'yc-edit-henkan)
(define-key yc-edit-mode-map "\C-m" 'yc-edit-kakutei)
(define-key yc-edit-mode-map "\C-k" 'yc-edit-kill-line)
;(define-key yc-edit-mode-map "\C-p" 'yc-edit-katakana)
;(define-key yc-edit-mode-map "\C-n" 'yc-edit-alphabet)
(define-key yc-edit-mode-map "\C-p" 'yc-edit-previous)
(define-key yc-edit-mode-map "\C-n" 'yc-edit-next)
(define-key yc-edit-mode-map [up] 'yc-edit-end-of-fence)
(define-key yc-edit-mode-map [down] 'yc-edit-beginning-of-fence)
(define-key yc-edit-mode-map [right] 'yc-edit-forward-char)
(define-key yc-edit-mode-map [left] 'yc-edit-backward-char)

;; $BFI$_J8;zNs$rJQ49$9$k(B
(defun yc-edit-henkan ()
  "$BFI$_JT=8Cf$K$R$i2>L>(B-$B4A;zJQ49$9$k(B"
  (interactive)
  (yc-yomi-post-insert)
  (if (yc-server-check) (yc-init))
  (if (not (and (yc-server-check) (yc-init-p)))
      (progn
	(beep)
	(error (format "YC: can't connect cannaserver: %s" yc-server-host)))
    (setq yc-edit-mode nil)
    (delete-region yc-fence-start yc-fence-end)
    (yc-edit-fix-romaji)
    (insert yc-fence-yomi)
    (set-marker yc-fence-end (point))
    (yc-henkan-region yc-fence-start yc-fence-end)))

;; $BJT=8Cf$K;z<oJQ49$9$k(B
(defun yc-edit-jisyu (func)
  (setq yc-edit-mode nil)
  (delete-region yc-fence-start yc-fence-end)
  (insert yc-fence-yomi)
  (set-marker yc-fence-end (point))
  (yc-henkan-region yc-fence-start yc-fence-end)
  (setq yc-henkan-list (yc-resize-pause (yc-get conv) yc-mark
					(yc-strlen (yc-conv-rH yc-fence-yomi)))
	yc-mark-list (list 0)
	yc-mark-max (list 0))
  (funcall func))

;; $B%+%?%+%J$K;z<oJQ49$9$k(B
(defun yc-edit-katakana ()
  "$BFI$_JT=8Cf$K%+%?%+%JJQ49$9$k(B"
  (interactive)
  (yc-edit-jisyu 'yc-katakana))

;; alphabet$B$K;z<oJQ49$9$k(B
(defun yc-edit-alphabet ()
  "$BFI$_JT=8Cf$K(Balphabet$BJQ49$9$k(B"
  (interactive)
  (yc-edit-jisyu 'yc-alphabet))

(defun yc-edit-fix-romaji ()
  (if (not (string= (yc-conv-rH (apply 'concat yc-hiragana-list)) ;; 2002.08.23
		    (yc-conv-rH (apply 'concat yc-romaji-list))))
      (let ((c (mapcar 'char-to-string
		       (append (yc-conv-Hr (apply 'concat yc-hiragana-list))
			       nil))))
	(yc-yomi-reset)
	(while c
	  (yc-yomi-insert (car c))
	  (setq c (cdr c))))))

(defun yc-edit-jisyu-internal ()
  (yc-yomi-post-insert)
  (setq yc-hiragana-list
	(cond ((= yc-repeat 0)
	       (car (yc-conv-rH-list yc-fence-yomi 0)))
	      ((= yc-repeat 1)
	       (mapcar 'yc-conv-Hk (car (yc-conv-rH-list yc-fence-yomi 0))))
	      ((= yc-repeat 2)
	       (if yc-enable-hankaku
		   (mapcar 'yc-conv-Hh (car (yc-conv-rH-list yc-fence-yomi 0)))
		 (mapcar 'yc-conv-aA (yc-generate-romaji-list yc-fence-yomi))))
	      ((= yc-repeat 3)
	       (if yc-enable-hankaku
		   (mapcar 'yc-conv-aA (yc-generate-romaji-list yc-fence-yomi))
		 (yc-generate-romaji-list yc-fence-yomi)))
	      ((= yc-repeat 4) (yc-generate-romaji-list yc-fence-yomi))))
  (setq yc-yomi-list-point (length yc-hiragana-list)))

(defun yc-edit-previous ()
  (interactive)
  (setq yc-repeat (if (or (eq last-command 'yc-edit-previous)
			  (eq last-command 'yc-edit-next))
		      (mod (1- yc-repeat) (- 5 (if yc-enable-hankaku 0 1)))
		    (yc-edit-fix-romaji) (- 4 (if yc-enable-hankaku 0 1))))
  (yc-edit-jisyu-internal)
  (yc-edit-post-command-function))

(defun yc-edit-next ()
  (interactive)
  (setq yc-repeat (if (or (eq last-command 'yc-edit-previous)
			  (eq last-command 'yc-edit-next))
		      (mod (1+ yc-repeat) (- 5 (if yc-enable-hankaku 0 1)))
		    (yc-edit-fix-romaji) 1))
  (yc-edit-jisyu-internal)
  (yc-edit-post-command-function))

;; $B:G=i$NFI$_$K0\F0$9$k(B
(defun yc-edit-beginning-of-fence ()
  "$BFI$_JT=8Cf$K:G=i$NFI$_$K0\F0$9$k(B"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-bob)
  (yc-edit-post-command-function))

;; $B:G8e$NFI$_$K0\F0$9$k(B
(defun yc-edit-end-of-fence ()
  "$BFI$_JT=8Cf$K:G8e$NFI$_$K0\F0$9$k(B"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-eob)
  (yc-edit-post-command-function))

;; $B<!$NFI$_$K0\F0$9$k(B
(defun yc-edit-forward-char ()
  "$BFI$_JT=8Cf$K<!$NFI$_$K0\F0$9$k(B"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-next)
  (yc-edit-post-command-function))

;; $BA0$NFI$_$K0\F0$9$k(B
(defun yc-edit-backward-char ()
  "$BFI$_JT=8Cf$KA0$NFI$_$K0\F0$9$k(B"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-prev)
  (yc-edit-post-command-function))

;; $BA0$NFI$_$r:o=|$9$k(B
(defun yc-edit-backward-delete-char ()
  "$BFI$_JT=8Cf$KA0$NFI$_$r:o=|$9$k(B"
  (interactive)
  (yc-yomi-prev)
  (yc-yomi-delete)
  (if (string= yc-fence-yomi "")
      (yc-edit-cancel)
    (yc-edit-post-command-function)))

;; $B%+!<%=%k$N$"$kFI$_$r:o=|$9$k(B
(defun yc-edit-delete-char ()
  "$BFI$_JT=8Cf$K8=:_$NFI$_$r:o=|$9$k(B"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-delete)
  (if (string= yc-fence-yomi "")
      (yc-edit-cancel)
    (yc-edit-post-command-function)))

;; $B%+!<%=%k$N$"$kFI$_$+$i:G8e$NFI$_$^$G:o=|$9$k(B
(defun yc-edit-kill-line ()
  "$BFI$_JT=8Cf$K8=:_$NFI$_$+$i:G8e$NFI$_$^$G:o=|$9$k(B"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-kill)
  (if (string= yc-fence-yomi "")
      (yc-edit-cancel)
    (yc-edit-post-command-function)))

;; $BFI$_$NJT=8$N<h$j>C$9(B
(defun yc-edit-cancel ()
  "$BFI$_$NJT=8$r<h$j;_$a$k(B"
  (interactive)
  (yc-yomi-reset)
  (yc-fence-mode nil)
  (setq yc-edit-mode nil
	yc-fence-yomi nil
	yc-henkan-list nil
	yc-fence-start nil
	yc-fence-end nil))

;; $BFI$_$NJT=8$r=*$j!"FI$_J8;zNs$r$=$N$^$^3NDj$9$k(B
(defun yc-edit-kakutei ()
  "$BFI$_$r$=$N$^$^3NDj$9$k(B"
  (interactive)
  (yc-yomi-post-insert)
  (yc-fence-mode nil)
;  (insert (yc-conv-rH yc-fence-yomi))
  (insert (yc-yomi-hiragana))
  (yc-yomi-reset)
  (setq yc-edit-mode nil
	yc-fence-yomi nil
	yc-henkan-list nil
	yc-fence-start nil
	yc-fence-end nil))

;; $BFI$_JT=8Cf$N%-!<F~NO(B
(defun yc-edit-self-insert ()
  "$BFI$_$rF~NO$9$k(B"
  (interactive)
  (yc-self-insert-internal))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $B$R$i2>L>F~NO%b!<%I(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key yc-input-mode-map (cond ((vectorp yc-rK-trans-key)
				     (vconcat [?\C-c] yc-rK-trans-key))
				    ((stringp yc-rK-trans-key)
				     (concat "\C-c" yc-rK-trans-key)))
  'yc-wclist-mode)
(let ((i (1+ ? )))
  (while (< i ?\177)
    (define-key yc-input-mode-map (char-to-string i) 'yc-input-self-insert)
    (setq i (1+ i))))

(defun yc-input-mode-function ()
  (setq inactivate-current-input-method-function 'yc-inactivate)
  (setq current-input-method-title "$B$"(B")
  (yc-open)
  (remove-hook 'input-method-activate-hook 'yc-input-mode-function))

(defun yc-input-mode (arg)
  "$BFI$_JT=8%b!<%I!#(B
$BF~NO$5$l$?%m!<%^;z$r$R$i2>L>$KJQ49$7$J$,$iF~NO$9$k%b!<%I!#(B"
  (interactive "P")
    (when (not (local-variable-p 'yc-input-mode (current-buffer)))
      (make-local-variable 'yc-input-mode))
    (setq yc-input-mode (if (null arg) (not yc-input-mode)
			  (> (prefix-numeric-value arg) 0)))
    (if yc-input-mode
	(progn
	  (setq inactivate-current-input-method-function 'yc-inactivate)
	  (setq current-input-method-title "$B$"(B")
	      (add-hook 'input-method-activate-hook 'yc-input-mode-function);)
	  (if (eq (selected-window) (minibuffer-window))
	      (add-hook 'minibuffer-exit-hook 'yc-exit-from-minibuffer)))
      (setq inactivate-current-input-method-function nil)
      (setq current-input-method-title nil))
    (force-mode-line-update t));)

(defun yc-exit-from-minibuffer ()
  (inactivate-input-method)
  (when (<= (minibuffer-depth) 1)
    (remove-hook 'minibuffer-exit-hook 'yc-exit-from-minibuffer)))

(defun yc-input-self-insert ()
  "$BFI$_$NF~NO!#(B
$BF~NO$5$l$?%m!<%^;z$r$R$i2>L>$KJQ49$7$J$,$iFI$_$rF~NO$9$k!#(B"
  (interactive)
  (when yc-henkan-mode (yc-kakutei))
  (yc-yomi-reset)
  (setq yc-edit-mode t
	yc-mark 0
	yc-fence-start (copy-marker (point-marker))
	yc-fence-end (copy-marker (point-marker)))
  (yc-self-insert-internal))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; $BJQ49%b!<%I(B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(let ((i 0))
  (while (<= i ?\177)
    (define-key yc-henkan-mode-map (char-to-string i)
      'yc-kakutei-and-self-insert)
    (setq i (1+ i))))
(define-key yc-henkan-mode-map "\C-m" 'yc-kakutei)
(define-key yc-henkan-mode-map "\C-g" 'yc-cancel)
(define-key yc-henkan-mode-map "\C-n" 'yc-next)
(define-key yc-henkan-mode-map yc-rK-trans-key 'yc-next)
(define-key yc-henkan-mode-map " "    'yc-modeless-next)
(define-key yc-henkan-mode-map "\C-p" 'yc-previous)
(define-key yc-henkan-mode-map "\C-f" 'yc-forward)
(define-key yc-henkan-mode-map "\C-b" 'yc-backward)
(define-key yc-henkan-mode-map "\C-a" 'yc-beginning-of-fence)
(define-key yc-henkan-mode-map "\C-e" 'yc-end-of-fence)
(define-key yc-henkan-mode-map "\C-i" 'yc-shrink)
(define-key yc-henkan-mode-map "\C-o" 'yc-enlarge)
(define-key yc-henkan-mode-map "\C-t" 'yc-kakutei-and-touroku)
(define-key yc-henkan-mode-map "\177" 'yc-hiragana)
(define-key yc-henkan-mode-map [backspace] 'yc-hiragana)
(define-key yc-henkan-mode-map "\C-h" 'yc-hiragana)
(define-key yc-henkan-mode-map "\C-u" 'yc-alphabet2)
(define-key yc-henkan-mode-map "\C-l" 'yc-alphabet)
(define-key yc-henkan-mode-map "\C-k" 'yc-katakana)
(define-key yc-henkan-mode-map [up] 'yc-previous)
(define-key yc-henkan-mode-map [down] 'yc-next)
(define-key yc-henkan-mode-map [right] 'yc-forward)
(define-key yc-henkan-mode-map [left] 'yc-backward)

(defvar yc-symbol-list nil)

;; cannaserver $B$+$iJQ498uJd$r<hF@$9$k4X?t(B
(defun yc-get-kouho-list ()
  (when (not yc-kouho-list)
    (let* ((jisyu-list (yc-make-jisyu-list))
	   (alpha (car jisyu-list))
	   (symbol (and (= (length alpha) 1)
			(yc-get-symbol-list (string-to-char alpha)))))
      (if symbol
	  (progn
	    (setq yc-symbol-list (cons (cons alpha nil) yc-symbol-list))
	    (setq yc-kouho-list symbol)
	    (setcar (nthcdr yc-mark yc-mark-max) 0))
	(setq yc-symbol-list (cons nil yc-symbol-list))
	(condition-case nil
	    (progn
	      (setq yc-kouho-list
		    (yc-get-candidacy-list (yc-get conv) yc-mark 4096))
	      (setcar (nthcdr yc-mark yc-mark-max) (1- (length yc-kouho-list)))
	      (if (<= (nth yc-mark yc-mark-max) 0)
		  (setq yc-kouho-list jisyu-list)
		(setcdr (nthcdr (- (length yc-kouho-list) 2) yc-kouho-list)
			jisyu-list)))
	  (yc-trap-server-down
	   (setq yc-kouho-list jisyu-list)
	   (setcar (nthcdr yc-mark yc-mark-max) 0)
	   (signal 'yc-trap-server-down (list yc-server-host)))))
      (setcar (nthcdr yc-mark yc-mark-list)
	      (- (length yc-kouho-list)
		 (length (member (nth yc-mark yc-henkan-list)
				 yc-kouho-list))))))
  (/= (nth yc-mark yc-mark-max) 0))

;; $B<!$N8uJd$rA*Br$9$k4X?t(B
(defun yc-next-kouho ()
  (setcar (nthcdr yc-mark yc-mark-list) (1+ (nth yc-mark yc-mark-list)))
  (when (<= (length yc-kouho-list) (nth yc-mark yc-mark-list))
    (setcar (nthcdr yc-mark yc-mark-list) 0))
  (if (car yc-symbol-list)
      (setcdr (car yc-symbol-list) (if (>= (nth yc-mark yc-mark-list)
					   (nth yc-mark yc-mark-max))
				       (- (nth yc-mark yc-mark-list)
					  (nth yc-mark yc-mark-max))))))

;; $BD>A0$N8uJd$rA*Br$9$k4X?t(B
(defun yc-prev-kouho ()
  (setcar (nthcdr yc-mark yc-mark-list) (1- (nth yc-mark yc-mark-list)))
  (when (> 0 (nth yc-mark yc-mark-list))
    (setcar (nthcdr yc-mark yc-mark-list) (1- (length yc-kouho-list))))
  (if (car yc-symbol-list)
      (setcdr (car yc-symbol-list) (if (> (nth yc-mark yc-mark-list)
					  (nth yc-mark yc-mark-max))
				       (- (nth yc-mark yc-mark-list)
					  (nth yc-mark yc-mark-max))))))

;; $B<!$NJ8@a$rA*Br$9$k4X?t(B
(defun yc-forward-bunsetsu (&optional arg)
  (if arg
      (setq yc-mark arg)
    (setq yc-mark (1+ yc-mark))
    (when (>= yc-mark (length yc-henkan-list))
      (setq yc-mark 0)))
  (yc-yomi yc-mark)
  (setq yc-kouho-list nil))

;; $BD>A0$NJ8@a$rA*Br$9$k4X?t(B
(defun yc-backward-bunsetsu (&optional arg)
  (if arg
      (setq yc-mark arg)
    (setq yc-mark (1- yc-mark))
    (when (> 0 yc-mark)
      (setq yc-mark (1- (length yc-henkan-list)))))
  (yc-yomi yc-mark)
  (setq yc-kouho-list nil))

;; $B8=:_$NJ8@a$N(B alphabet $B$r<h$j=P$94X?t(B
(defun yc-alphabet-internal (&optional hiragana)
  (if (not (eval (cons 'and
		       (mapcar (lambda (ch) (eq (yc-char-charset ch) 'ascii))
			       (append yc-fence-yomi nil)))))
      (yc-conv-Hr (yc-yomi))
    (let* ((hira0 "")
	   (idx 0)
	   (res (yc-conv-rH-list yc-fence-yomi 0))
	   (hlst (car res))
;	   (rlst (cadr res))
	   (rlst (yc-generate-romaji-list yc-fence-yomi))
	   (hira1 "")
	   (hira2)
	   (hprefix "")
	   (hira3 "")
	   (hsuffix "")
	   (roma0 ""))

      (while (< idx yc-mark)
	(setq hira0 (concat hira0 (yc-yomi idx))
	      idx (1+ idx)))

      (setq idx 0)
      (while (string< hira1 hira0)
	(setq hira1 (concat hira1 (nth idx hlst))
	      idx (1+ idx)))
      (setq hira2 (yc-yomi))
      (when hira2
	(when (not (string= hira1 hira0))
	  (setq hprefix (substring (nth (1- idx) hlst)
				   (- (length (substring hira1
							 (length hira0)))))
		hira2 (substring hira2 (length hprefix))))

	(if (string= hira2 "")
	    (yc-conv-Hr hprefix)

	  (while (string< hira3 hira2)
	    (setq roma0 (concat roma0 (nth idx rlst))
		  hira3 (concat hira3 (nth idx hlst))
		  idx (1+ idx)))

	  (if (string= hira3 hira2)
	      (concat (yc-conv-Hr hprefix) roma0)
;	    (yc-debug (append (list idx) rlst (list hira0 hira1 hira2 hira3)))
	    (setq roma0 (substring roma0 0 (- (length (nth (1- idx) rlst))))
		  hira3 (substring hira3 0 (- (length (nth (1- idx) hlst))))
		  hsuffix (substring hira2 (length hira3)))
	    (concat (yc-conv-Hr hprefix) roma0 (yc-conv-Hr hsuffix))))))))


;; $B0lMw%b!<%I$K0MB8$;$:$K<!8uJd$rA*Br$9$kFbIt4X?t(B
(defun yc-modeless-next-internal ()
  (cond (yc-henkan-mode (yc-get-kouho-list)
			(yc-next-kouho))
	(yc-select-mode (yc-select-forward))))

;; $B0lMw%b!<%I$K0MB8$;$:$KA08uJd$rA*Br$9$kFbIt4X?t(B
(defun yc-modeless-previous-internal ()
  (cond (yc-henkan-mode (yc-get-kouho-list)
			(yc-prev-kouho))
	(yc-select-mode (yc-select-backward))))

;; $B;z<oJQ49%j%9%H$r:n@.$9$k(B
(defun yc-make-jisyu-list ()
  (condition-case nil
      (let* ((hiragana (yc-yomi))
	     (katakana (yc-conv-Hk hiragana))
	     (hankaku  (yc-conv-Hh hiragana))
	     (alpha    (yc-alphabet-internal hiragana))
	     (alpha2   (yc-conv-aA alpha)))
	(if yc-enable-hankaku
	    (list alpha alpha2 hankaku katakana hiragana)
	  (list alpha alpha2 katakana hiragana)))
;;	(list hiragana katakana hankaku alpha2 alpha)) ; orig: t.nakao@ntta.com
    (yc-trap-server-down nil)))

;; $B;z<oJQ49=hM}(B
(defun yc-jisyu (arg)
  (yc-get-kouho-list)
  (setcar (nthcdr yc-mark yc-mark-list)
	  (cond ((eq arg 'hiragana) (1- (length yc-kouho-list)))
		((eq arg 'katakana) (- (length yc-kouho-list) 2))
		((eq arg 'hankaku)  (- (length yc-kouho-list) 3))
		((eq arg 'alpha2)   (- (length yc-kouho-list) 4))
		((eq arg 'alpha)    (- (length yc-kouho-list) 5)))))

;; $B;z<oJQ49$r9T$&FbIt4X?t(B
(defun yc-jisyu-henkan-internal ()
  (cond ((= (mod yc-repeat 5) 0) (yc-jisyu 'hiragana)) ; $B$R$i$,$J(B
	((= (mod yc-repeat 5) 1) (yc-jisyu 'katakana)) ; $B%+%?%+%J(B
	((= (mod yc-repeat 5) 2) (yc-jisyu 'hankaku)) ; $BH>3Q%+%J(B
	((= (mod yc-repeat 5) 3) (yc-jisyu 'alpha2)) ; $B#a#l#p#h#a#b#e#t(B
	((= (mod yc-repeat 5) 4) (yc-jisyu 'alpha)))) ; alphabet


;; $B%j!<%8%g%s$r%m!<%^;z4A;zJQ49$9$k4X?t(B
;; $B$R$i$,$J4A;zJQ49$b2DG=(B
(defun yc-henkan-region (b e)
  "$B;XDj$5$l$?(B region $B$r4A;zJQ49$9$k(B"
  (interactive "*r")
  (yc-init)
  (condition-case err
      (when (/= b e)
	(setq yc-henkan-mode t
	      yc-fence-start (copy-marker b)
	      yc-fence-end (copy-marker e)
	      yc-fence-yomi (buffer-substring b e)
	      yc-henkan-list (yc-begin-convert
			      yc-mode-zen-hira-henkan
			      (yc-get conv)
			      (if yc-hiragana-list (yc-yomi-hiragana)
				(yc-conv-kH (yc-conv-rH
					     (yc-conv-Aa yc-fence-yomi)))))
	      yc-mark-list (make-list (length yc-henkan-list) 0)
	      yc-mark-max (make-list (length yc-henkan-list) 0)
	      yc-mark 0
	      yc-bunsetsu-yomi-list nil)
	(yc-post-command-function))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (setq yc-henkan-mode nil)) ))

;; $BJQ49$r3NDj$9$k4X?t(B
(defun yc-kakutei ()
  "$B4A;zJQ49$r3NDj$9$k(B"
  (interactive)
  (yc-kakutei-internal))
(defun yc-kakutei-internal ()
  (let ((idx 0)
	(yc-mark-max yc-mark-max))
    (while yc-mark-max
      (when (>= (nth idx yc-mark-list) (car yc-mark-max))
	(setcar (nthcdr idx yc-mark-list) 0))
      (setq idx (1+ idx))
      (setq yc-mark-max (cdr yc-mark-max))))
  (setq yc-symbol-list (reverse (delq nil yc-symbol-list)))
  (while yc-symbol-list
    (when (cdar yc-symbol-list)
      (yc-put-symbol (string-to-char (caar yc-symbol-list))
		     (cdar yc-symbol-list)))
    (setq yc-symbol-list (cdr yc-symbol-list)))
  (condition-case nil
      (yc-end-convert (yc-get conv) (length yc-henkan-list) 1 yc-mark-list)
    (yc-trap-server-down nil))
  (yc-fence-mode nil)
  (insert (apply 'concat yc-henkan-list))
  (set-marker yc-fence-end (point))
  (setq yc-henkan-mode nil
	yc-mark-list nil
	yc-mark-max nil
	yc-kouho-list nil
	yc-romaji-list nil
	yc-hiragana-list nil)
  (when yc-isearch
    (setq yc-isearch nil)
    (if (featurep 'xemacs)
	(isearch-nonincremental-exit-minibuffer)
      (exit-minibuffer) ))
  (force-mode-line-update))

;(eval-when-compile
;  (when (boundp 'byte-compile-depth)
;    (condition-case nil
;	(require 'viper)
;      (error nil))))

(defun yc-viper-minibuffer-kakutei ()
  "viper-mode $B$r;HMQCf$G(B minibuffer $B$G3NDj$rF~NO$5$l$?$H$-$N4X?t!#(B
$BJQ49J8;zNs$r3NDj$9$k$@$1$G(B minibuffer $B$rH4$1$J$$!#(B"
  (interactive)
  (if (and (or yc-henkan-mode yc-edit-mode)
	   (minibuffer-window-active-p (selected-window)))
      (if yc-edit-mode (yc-edit-kakutei)
	(when yc-select-mode (yc-choice))
	(yc-kakutei))
    (eval '(viper-exit-minibuffer))))

(if (boundp 'viper-minibuffer-map)
    (eval
     '(define-key viper-minibuffer-map "\C-m" 'yc-viper-minibuffer-kakutei))
  (eval-after-load "viper"
    '(define-key viper-minibuffer-map "\C-m" 'yc-viper-minibuffer-kakutei)))

;; $BJQ49Cf$NJ8;zNs$r3NDj$73NDj$7$?J8;zNs$r<-=qEPO?$9$k(B
(defun yc-kakutei-and-touroku ()
  "$B4A;zJQ49$r3NDj$7!"JQ49Cf$@$C$?J8;zNs$r<-=qEPO?$9$k(B"
  (interactive)
  (yc-kakutei)
  (yc-touroku-region yc-fence-start yc-fence-end))

;; $BJQ49$r3NDj$7F~NO$5$l$?%-!<$r:FF~NO$9$k4X?t(B
(defun yc-kakutei-and-self-insert (arg)
  "$B4A;zJQ49$r3NDj$7!"F~NO$5$l$?J8;z$rF~NO$9$k(B"
  (interactive "P")
  (yc-kakutei)
  (setq unread-command-events (list last-command-event)))

;; $BJQ49$r<h$j>C$94X?t(B
;; $BJQ49A0$N>uBV$KLa$9(B
(defun yc-cancel ()
  "$B4A;zJQ49$rCf;_$7!"JQ49A0$N>uBV$KLa$9(B"
  (interactive)
  (setq yc-mark-list (make-list (length yc-henkan-list) 0))
  (condition-case nil
      (yc-end-convert (yc-get conv) (length yc-henkan-list) 0 yc-mark-list)
    (yc-trap-server-down nil))
  (if yc-romaji-list
      (progn
	(setq yc-henkan-mode nil
	      yc-mark-list nil
	      yc-mark-max nil
	      yc-kouho-list nil
	      yc-symbol-list nil)
	(setq yc-edit-mode t)
	(yc-edit-post-command-function))
    (yc-fence-mode nil)
    (setq buffer-undo-list (primitive-undo 1 buffer-undo-list)
	  yc-kouho-list nil
	  yc-mark-list nil
	  yc-mark-max nil
	  yc-henkan-mode nil
	  yc-symbol-list nil)
    (set-marker yc-fence-end (point)) ; reconversion after yc-cancel
    (when yc-isearch
      (setq yc-isearch nil)
      (if (featurep 'xemacs)
	  (isearch-nonincremental-exit-minibuffer)
	(exit-minibuffer)))))

;; $BJQ49Cf$NJ8@aD9$rJQ99$9$k4X?t(B
(defun yc-resize-bunsetsu (arg)
  (let* ((len (if (< arg 0)
		  (let ((pos (string-match
			      "$B$&!+(B$" (or (nth yc-mark yc-henkan-list) ""))))
		    (cond ((not pos) -2)
			  ((> pos 0)
			   (- (yc-strlen (nth yc-mark yc-henkan-list)) 2))
			  (t 0)))
		(cond ((eq (nth (1+ yc-mark) yc-henkan-list) nil) 0)
		      ((eq (string-match
			    "^$B$&!+(B" (nth (1+ yc-mark) yc-henkan-list)) 0)
		       (+ (yc-strlen (nth yc-mark yc-henkan-list)) 2))
		      (t -1))))
	 (hlst (condition-case nil
		   (yc-resize-pause (yc-get conv) yc-mark len)
		 (nthcdr yc-mark yc-henkan-list)))
	 (mlst (make-list (length hlst) 0)))
    (if (= yc-mark 0)
	(setq yc-henkan-list hlst
	      yc-mark-list mlst
	      yc-mark-max (copy-sequence mlst))
      (setcdr (nthcdr (1- yc-mark) yc-henkan-list) hlst)
      (setcdr (nthcdr (1- yc-mark) yc-mark-list) mlst)
      (setcdr (nthcdr (1- yc-mark) yc-mark-max) (copy-sequence mlst))))
  (yc-yomi yc-mark t)
  (setq yc-kouho-list nil)
  (yc-post-command-function))

;; $BJQ49Cf$NJ8@a$r?-$P$94X?t(B
(defun yc-enlarge ()
  "$BJQ49J8@a$r3HD%$9$k(B"
  (interactive)
  (condition-case err
      (yc-resize-bunsetsu 1)
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; $BJQ49Cf$NJ8@a$r=L$a$k4X?t(B
(defun yc-shrink ()
  "$BJQ49Cf$NJ8@a$r=L>.$9$k(B"
  (interactive)
  (condition-case err
      (yc-resize-bunsetsu -1)
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; $B0lMw%b!<%I$K$+$+$o$i$:8uJd$rA*Br$9$k4X?t(B
(defun yc-modeless-kouho (lst)
  (condition-case err
      (progn
	(setq yc-repeat (if (eq last-command this-command) (1+ yc-repeat) 0))
	(funcall lst)
	(if (and (not yc-select-mode) (>= yc-repeat yc-select-count))
	    (yc-select)
	  (yc-post-command-function)))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; $B0lMw%b!<%I$K4X$o$i$:<!8uJd$rA*Br$9$k4X?t(B
(defun yc-modeless-next ()
  "$B0lMw%b!<%I$K4X$o$i$:<!8uJd$rA*Br$9$k(B"
  (interactive)
  (yc-modeless-kouho 'yc-modeless-next-internal))

;; $B0lMw%b!<%I$K4X$o$i$:A08uJd$rA*Br$9$k4X?t(B
(defun yc-modeless-previous ()
  "$B0lMw%b!<%I$K4X$o$i$:A08uJd$rA*Br$9$k(B"
  (interactive)
  (yc-modeless-kouho 'yc-modeless-previous-internal))

;; $B;z<oJQ49$r%5%$%/%j%C%/$K9T$&4X?t(B
(defun yc-jisyu-lotate (key)
  (when yc-select-mode (yc-select-cancel))
  (setq yc-repeat (if (eq last-command this-command) (1+ yc-repeat) key))
  (yc-jisyu-henkan-internal)
  (yc-post-command-function))

;; $B0lMw%b!<%I$K4X$o$i$:;z<oJQ49$r9T$&4X?t(B
(defun yc-jisyu-henkan ()
  "$B0lMw%b!<%I$K4X$o$i$:;z<oJQ49$r9T$&(B"
  (interactive)
  (yc-jisyu-lotate 0))

;; $B$R$i$,$JJQ49$r9T$&4X?t(B
(defun yc-hiragana ()
  "$B0lMw%b!<%I$K4X$o$i$:;z<oJQ49$r$9$k!#(B
$B$R$i$,$J"*%+%?%+%J"*H>3Q%+%J"*#a#l#p#h#a#b#e#t"*(Balphabet
$B$N=g$K%k!<%W$9$k(B"
  (interactive)
  (yc-jisyu-lotate 0))

;; $B%+%?%+%JJQ49$r9T$&4X?t(B
(defun yc-katakana ()
  "$B0lMw%b!<%I$K4X$o$i$:;z<oJQ49$r$9$k!#(B
$B%+%?%+%J"*H>3Q%+%J"*#a#l#p#h#a#b#e#t"*(Balphabet$B"*$R$i$,$J(B
$B$N=g$K%k!<%W$9$k(B"
  (interactive)
  (yc-jisyu-lotate 1))

;; $BH>3Q%+%JJQ49$r9T$&4X?t(B
(defun yc-hankaku ()
  "$B0lMw%b!<%I$K4X$o$i$:;z<oJQ49$r$9$k!#(B
$BH>3Q%+%J"*#a#l#p#h#a#b#e#t"*(Balphabet$B"*$R$i$,$J"*%+%?%+%J(B
$B$N=g$K%k!<%W$9$k(B"
  (interactive)
  (yc-jisyu-lotate 2))

;; $B#a#l#p#h#a#b#e#tJQ49$r9T$&4X?t(B
(defun yc-alphabet2 ()
  "$B0lMw%b!<%I$K4X$o$i$:;z<oJQ49$r$9$k!#(B
$B#a#l#p#h#a#b#e#t"*(Balphabet$B"*$R$i$,$J"*%+%?%+%J"*H>3Q%+%J(B
$B$N=g$K%k!<%W$9$k(B"
  (interactive)
  (yc-jisyu-lotate 3))

;; alphabet$BJQ49$r9T$&4X?t(B
(defun yc-alphabet ()
  "$B0lMw%b!<%I$K4X$o$i$:;z<oJQ49$r$9$k!#(B
alphabet$B"*$R$i$,$J"*%+%?%+%J"*H>3Q%+%J"*#a#l#p#h#a#b#e#t(B
$B$N=g$K%k!<%W$9$k(B"
  (interactive)
  (yc-jisyu-lotate 4))

;; $B<!8uJd$rA*Br$9$k4X?t(B($B0lMw%b!<%I$G$O;H$($J$$(B)
(defun yc-next ()
  "$B<!8uJd$rA*Br$9$k(B"
  (interactive)
  (condition-case err
      (progn
	(yc-get-kouho-list)
	(yc-next-kouho)
	(yc-post-command-function))
    (yc-trap-server-down 
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; $BA08uJd$rA*Br$9$k4X?t(B($B0lMw%b!<%I$G$O;H$($J$$(B)
(defun yc-previous ()
  "$BA08uJd$rA*Br$9$k(B"
  (interactive)
  (condition-case err
      (progn
	(yc-get-kouho-list)
	(yc-prev-kouho)
	(yc-post-command-function))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; $B<!J8@a$rA*Br$9$k4X?t(B($B0lMw%b!<%I$G$O;H$($J$$(B)
(defun yc-forward ()
  "$B<!J8@a$KBP>]J8@a$r0\F0$9$k(B"
  (interactive)
  (condition-case err
      (progn
	(yc-forward-bunsetsu)
	(yc-post-command-function))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; $BA0J8@a$rA*Br$9$k4X?t(B($B0lMw%b!<%I$G$O;H$($J$$(B)
(defun yc-backward ()
  "$BA0J8@a$KBP>]J8@a$r0\F0$9$k(B"
  (interactive)
  (condition-case err
      (progn
	(yc-backward-bunsetsu)
	(yc-post-command-function))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; $B@hF,J8@a$rA*Br$9$k4X?t(B($B0lMw%b!<%I$G$O;H$($J$$(B)
(defun yc-beginning-of-fence ()
  "$B@hF,J8@a$KBP>]J8@a$r0\F0$9$k(B"
  (interactive)
  (condition-case err
      (progn
	(yc-backward-bunsetsu 0)
	(yc-post-command-function))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; $B:G=*J8@a$rA*Br$9$k4X?t(B($B0lMw%b!<%I$G$O;H$($J$$(B)
(defun yc-end-of-fence ()
  "$B:G=*J8@a$KBP>]J8@a$r0\F0$9$k(B"
  (interactive)
  (condition-case err
      (progn
	(yc-forward-bunsetsu (1- (length yc-henkan-list)))
	(yc-post-command-function))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;;;
;;; human interface
;;;
(define-key yc-mode-map yc-rK-trans-key 'yc-rK-trans)
(define-key yc-mode-map "\M-j" 'yc-rHkA-trans)
(define-key yc-mode-map (cond ((vectorp yc-rK-trans-key)
			       (vconcat [?\C-c] yc-rK-trans-key))
			      ((stringp yc-rK-trans-key)
			       (concat "\C-c" yc-rK-trans-key)))
  'yc-wclist-mode)

;; $B%m!<%^;z4A;zJQ49;~!"BP>]$H$9$k%m!<%^;z$r@_Dj$9$k$?$a$NJQ?t(B
(defvar yc-skip-chars nil)

;; yc-mode $B$N>uBVJQ994X?t(B
;;  $B@5$N0z?t$N>l9g!">o$K(B yc-mode $B$r3+;O$9$k(B
;;  {$BIi(B,0}$B$N0z?t$N>l9g!">o$K(B yc-mode $B$r=*N;$9$k(B
;;  $B0z?tL5$7$N>l9g!"(Byc-mode $B$r%H%0%k$9$k(B

;; buffer $BKh$K(B yc-mode $B$rJQ99$9$k(B
(defun yc-mode (&optional arg)
  "YC mode $B$O(B $B%m!<%^;z$+$iD>@\4A;zJQ49$9$k$?$a$N(B minor mode $B$G$9!#(B
$B0z?t$K@5?t$r;XDj$7$?>l9g$O!"(BYC mode $B$rM-8z$K$7$^$9!#(B

YC $B%b!<%I$,M-8z$K$J$C$F$$$k>l9g(B \\<yc-mode-map>\\[yc-rK-trans] $B$G(B
point $B$+$i9TF,J}8~$KF1<o$NJ8;zNs$,B3$/4V$r4A;zJQ49$7$^$9!#(B

$BF1<o$NJ8;zNs$H$O0J2<$N$b$N$r;X$7$^$9!#(B
$B!&H>3Q%+%?%+%J$H(Byc-stop-chars $B$K;XDj$7$?J8;z$r=|$/H>3QJ8;z(B
$B!&4A;z$r=|$/A43QJ8;z(B"
  (interactive "P")
  (yc-mode-internal arg nil))

;; $BA4%P%C%U%!$G(B yc-mode $B$rJQ99$9$k(B
(defun global-yc-mode (&optional arg)
  "YC mode $B$O(B $B%m!<%^;z$+$iD>@\4A;zJQ49$9$k$?$a$N(B minor mode $B$G$9!#(B
$B0z?t$K@5?t$r;XDj$7$?>l9g$O!"(BYC mode $B$rM-8z$K$7$^$9!#(B

YC $B%b!<%I$,M-8z$K$J$C$F$$$k>l9g(B \\<yc-mode-map>\\[yc-rK-trans] $B$G(B
point $B$+$i9TF,J}8~$KF1<o$NJ8;zNs$,B3$/4V$r4A;zJQ49$7$^$9!#(B

$BF1<o$NJ8;zNs$H$O0J2<$N$b$N$r;X$7$^$9!#(B
$B!&H>3Q%+%?%+%J$H(Byc-stop-chars $B$K;XDj$7$?J8;z$r=|$/H>3QJ8;z(B
$B!&4A;z$r=|$/A43QJ8;z(B"
  (interactive "P")
  (yc-mode-internal arg t))

;; yc-mode $B$rJQ99$9$k6&DL4X?t(B
(defun yc-mode-internal (arg global)
  (or (local-variable-p 'yc-mode (current-buffer))
      (make-local-variable 'yc-mode))
  (if global
      (progn
	(setq-default yc-mode (if (null arg) (not yc-mode)
				(> (prefix-numeric-value arg) 0)))
	(yc-kill-yc-mode))
    (setq yc-mode (if (null arg) (not yc-mode)
		    (> (prefix-numeric-value arg) 0))))
  (when (and yc-mode (not (yc-server-check)))
    (setq yc-mode nil)
    (beep)
    (error (format "YC: can't connect cannaserver: %s" yc-server-host)))
  (force-mode-line-update t)
  (when yc-mode
    (when (null yc-skip-chars) (yc-set-skip-chars yc-stop-chars))
    (yc-open)
    (run-hooks 'yc-mode-hook)))

;; buffer local $B$J(B yc-mode $B$r:o=|$9$k4X?t(B
(defun yc-kill-yc-mode ()
  (let ((buf (buffer-list)))
    (while buf
      (set-buffer (car buf))
      (kill-local-variable 'yc-mode)
      (setq buf (cdr buf)))))

;; $B%m!<%^;z4A;zJQ49BP>]$H$J$k(B alphabet $BNs$r@_Dj$9$k(B
(defun yc-set-skip-chars (stop-chars)
  (setq yc-skip-chars
	(let ((i (1+ ?\ ))
	      (stop-char-list (mapcar (if (fboundp 'char-to-int)
					  'char-to-int
					'(lambda (c) c))
				      (string-to-list stop-chars)))
	      (chars ""))
	  (while (< i ?\177)
	    (when (not (memq i stop-char-list))
	      (cond ((or (eq i ?\\) (eq i ?-) (eq i ?^))
		     (setq chars (concat chars "\\"))))
	      (setq chars (concat chars (char-to-string i))))
	    (setq i (1+ i)))
	  chars)))

;; $B%m!<%^;z4A;zJQ494X?t(B
(defun yc-rK-trans ()
  "$B%m!<%^;z4A;zJQ49$r$9$k!#(B

$B0J2<$N=g=x$K=hM}$r?6$jJ,$1$k!#(B

$B!&JQ49$r3NDj$7$?D>8e$N>l9g!"3NDj$7$?$P$+$j$NJ8;zNs$r:FJQ49$9$k!#(B
$B!&%+!<%=%k$+$i9TF,J}8~$K%m!<%^;zNs$,B3$/HO0O$G%m!<%^;z4A;zJQ49$r9T$&!#(B
$B!&%+!<%=%k$+$i9TF,J}8~$K!V$R$i$,$J!W$"$k$$$O!V%+%?%+%J!W(B
  $B$^$?$O!VA43Q1Q?t5-9f!W$,B3$/HO0O$G4A;zJQ49$r9T$&!#(B
$B!&JQ49Cf$O<!8uJd$H$J$k!#(B"
  (interactive)
;  (print last-command)			; DEBUG
  (cond

   (yc-henkan-mode
    ;; $BJQ49Cf$K8F$P$l$?$i(B yc-henkan-mode-map $B$KDj5A$5$l$F$$$k4X?t$r8F$V(B
    (setq yc-repeat (if (eq last-command 'yc-rK-trans) (1+ yc-repeat) 0))
    (funcall (lookup-key yc-henkan-mode-map yc-rK-trans-key))
    (if (and (not yc-select-mode) (>= yc-repeat yc-select-count))
	(yc-select)
      (yc-post-command-function)))

   ((or (eq last-command 'yc-kakutei)
	(eq last-command 'yc-cancel))	; reconversion after yc-cancel
    ;; $B3NDjD>8e$K8F$P$l$?$i:FJQ49(B
    (delete-region yc-fence-start yc-fence-end)
    (insert yc-fence-yomi)
    (set-marker yc-fence-end (point))
    (yc-henkan-region yc-fence-start yc-fence-end))

   (t
    ;; $B>e5-0J30$G8F$P$l$?$i?75,JQ49(B
    (setq yc-repeat 0)
    (cond

     ((eq (yc-char-charset (preceding-char)) 'ascii)
      ;; $B%+!<%=%kD>A0$,(B alphabet $B$@$C$?$i(B
      (let ((end (point))
	    (gap (yc-skip-chars-backward)))
	(goto-char end)
	(when (/= gap 0)
	  (setq yc-fence-yomi (buffer-substring (+ end gap) end))
	  (if (not (string= yc-fence-yomi ""))
	      (setq yc-henkan-mode t))
	  (yc-henkan-region (+ end gap) end))))

     ((yc-nkanji (preceding-char))
      ;; $B%+!<%=%kD>A0$,(B $BA43Q$G4A;z0J30(B $B$@$C$?$i(B
      (let ((end (point))
	    (start (let* ((pos (or (and (mark-marker)
					(marker-position (mark-marker))) 1))
			  (mark-check (>= pos (point))))
		     (while (and (or mark-check (< pos (point)))
				 (yc-nkanji (preceding-char)))
		       (backward-char))
		     (point))))
	(yc-henkan-region start end) ))))))

;; $BA43Q$G4A;z0J30$NH=Dj4X?t(B
(defun yc-nkanji (ch)
  (and (eq (yc-char-charset ch) 'japanese-jisx0208)
       (not (string-match "[$B0!(B-$Bt$(B]" (char-to-string ch)))))

;; $B%m!<%^;z4A;zJQ49;~!"JQ49BP>]$H$9$k%m!<%^;z$rFI$_Ht$P$94X?t(B
(defun yc-skip-chars-backward ()
  (let ((pos (or (and (markerp (mark-marker)) (marker-position (mark-marker)))
		 1)))
    (skip-chars-backward yc-skip-chars (and (< pos (point)) pos))))

;; $B%m!<%^;z(B-$BJ?2>L>(B-$B%+%?%+%JJQ49(B
(defun yc-rHkA-trans ()
  (interactive)
  (when yc-henkan-mode (yc-cancel))
  (cond
   (yc-edit-mode (yc-edit-katakana))
   ((eq last-command 'yc-rHkA-trans)
    (delete-region yc-fence-start yc-fence-end)
    (insert yc-fence-yomi)
    (set-marker yc-fence-end (point))
    (yc-henkan-region yc-fence-start yc-fence-end)
    (setq yc-henkan-list (yc-resize-pause (yc-get conv) yc-mark
					  (yc-strlen
					   (yc-conv-rH yc-fence-yomi)))
	  yc-mark-list (list 0)
	  yc-mark-max (list 0))
    (yc-hiragana) ; yc-hiragana $B$r8F$V$?$S$K;z<oJQ49$9$k(B
    (yc-kakutei-internal))

   (t
    ;; $B>e5-0J30$G8F$P$l$?$i?75,JQ49(B
    (setq yc-repeat 0)
    (cond
     ((eq (yc-char-charset (preceding-char)) 'ascii)
      ;; $B%+!<%=%kD>A0$,(B alphabet $B$@$C$?$i(B
      (let ((end (point))
	    (gap (yc-skip-chars-backward)))
	(goto-char end)
	(when (/= gap 0)
	  (setq yc-fence-yomi (buffer-substring (+ end gap) end))
	  (if (not (string= yc-fence-yomi ""))
	      (setq yc-henkan-mode t))
	  (yc-henkan-region (+ end gap) end)
	  (setq yc-henkan-list (yc-resize-pause (yc-get conv) yc-mark
						(yc-strlen 
						 (yc-conv-rH yc-fence-yomi)))
		yc-mark-list (list 0)
		yc-mark-max (list 0))
	  (yc-hiragana)
	  (yc-kakutei-internal))))
     ((yc-nkanji (preceding-char))
      ;; $B%+!<%=%kD>A0$,(B $BA43Q$G4A;z0J30$@$C$?$i(B
      (let ((end (point))
	    (start (let* ((pos (or (and (mark-marker)
					(marker-position (mark-marker))) 1))
			  (mark-check (>= pos (point))))
		     (while (and (or mark-check  (< pos (point)))
				 (yc-nkanji (preceding-char)))
		       (backward-char))
		     (point))))
	(yc-henkan-region start end)
	(setq yc-henkan-list (yc-resize-pause (yc-get conv) yc-mark
					      (yc-strlen 
					       (yc-conv-rH yc-fence-yomi)))
	      yc-mark-list (list 0)
	      yc-mark-max (list 0))
	(yc-hiragana)
	(yc-kakutei-internal) )) ))))

;; input method $BBP1~(B
(defun yc-activate (&rest arg)
  (yc-input-mode 1))
(defun yc-inactivate (&rest arg)
  (yc-input-mode -1))
(register-input-method
 "japanese-yc" "Japanese" 'yc-activate
 "$B$"(B" "Romaji -> Hiragana -> Kanji&Kana"
 nil)
(set-language-info "Japanese" 'input-method "japanese-yc")
;(setq default-input-method "japanese-yc"))

;(yc-setup)
;(when (and yc-connect-server-at-startup (yc-server-check))
;  (yc-init)
;  (force-yc-input-mode)
;  )

(defconst yc-version "5.0.0")
(provide 'yc)
