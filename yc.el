;;; yc.el by knak 2008.02.13

;;; YC は "Yet another Canna client" の略です。
;;; 頭文字をとると YACC になっちゃうんだもん (;_;)

;;;     配布条件: GPL
;;; 最新版配布元: http://www.ceres.dti.ne.jp/~knak/yc.html
;;; 作者の連絡先: http://www.ceres.dti.ne.jp/~knak/yc.html に記載

;;; YCの嬉しさ:
;;;
;;; YC は canna 対応パッチの当たっていない
;;; emacs を canna 対応にするプログラムです。
;;; 
;;; YC は ANK漢字変換をサポートします。
;;; YC は かな漢字変換をサポートします。

;;; YCの使い方:
;;;
;;; YCをロード後、C-\ (toggle-input-method) でかな漢字変換できます。
;;; YCをロード後、(yc-mode 1) を実行していると
;;; C-\ の入力を忘れて、buffer にいきなりローマ字を入力しても
;;; C-j で変換できます。
;;;
;;; YCをロード後、(global-yc-mode 1) を実行すると
;;; 全バッファでANK-漢字変換ができるようになります
;;;
;;; global-yc-mode と yc-mode の違い:
;;;
;;; M-x yc-mode は現在のバッファに対して YC のトグルをする
;;; M-x global-yc-mode は全バッファに対して YC のトグルをする
;;; global-yc-mode によるトグルは現在の buffer に対してトグルした結果を
;;; 全バッファに適用する
;;; つまり、現在のバッファで YC がオフ状態であれば
;;; global-yc-mode の結果はその他のバッファの YC の
;;; 状態にかかわらずオン状態になる

;;; .emacs の例:
;;;
;;; (setq yc-server-host "CANNAHOST") ; cannaserver を CANNAHOST で起動している
;;; (setq yc-rK-trans-key [henkan])   ; 変換キーを Henkan キーにする
;;; (setq yc-use-color t)             ; fence をカラー表示する
;;; (if (eq window-system 'x)
;;;    (setq yc-use-fence nil)        ; onX なら       || を表示しない
;;;  (setq yc-use-fence t))           ; onX でないなら || を表示する
;;; (load "yc")                       ; yc のロード
;;; (global-yc-mode 1)                ; 全バッファでascii-漢字変換可能にする

;;; YC の設定:
;;;
;;;  ・yc-canna-lib-path かんなのライブラリーパスを設定する(default.canna)
;;;  ・yc-canna-dic-path かんなの辞書パスを設定する(default.{kp,cbp})
;;;  ・yc-icanna-path    icanna へのパスを設定する
;;;  ・yc-rH-conv-dic    かんなのローマ字-ひら仮名変換テーブルを設定する
;;;  ・yc-select-count   一覧モードになる繰り返し数を設定する
;;;  ・yc-choice-stay    選択に文節を進めるか留まるかを設定する
;;;  ・yc-rK-trans-key   漢字変換キーを設定する
;;;  ・yc-stop-chars     ANK-漢字変換時に取り込む文字列に
;;;                      含めない文字列を設定する
;;;  ・yc-server-host    cannaserver の動いているホスト名を設定する
;;;  ・yc-use-fence      fence表示の飾り文字(||)を表示する
;;;  ・yc-use-color      fence表示をカラー表示する

;;; YC TIPS:
;;;
;;;  ・なにはともあれ C-j
;;;    漢字変換をしたかったら C-j これだけは覚えよう
;;;    後は、おなじみの emacs のカーソル移動コマンド体系で何とかなる
;;;    C-j が嫌なら yc ロード前に yc-rK-trans-key を設定する
;;;      (setq yc-rK-trans-key [henkan])
;;;
;;;  ・ひら仮名-漢字変換をするなら C-\
;;;    かんなの標準は C-o だけど YC は C-\ でひら仮名入力編集になる
;;;    (global-set-key "\C-o" 'toggle-input-method) で C-o にできる
;;;
;;;  ・alphabet と変換する文字列の間には SPC をいれる
;;;    C-j を入力すると半角文字列が続く区間を変換しようとする
;;;    alphabet と変換区間は SPC で分離するとスムーズに入力ができるようになる
;;;
;;;  ・alphabet と変換する文字列の間に SPC をいれたくなかったら C-@
;;;    YC は region がカーソルのある行に閉じている場合
;;;    region を変換しようとする
;;;
;;;  ・カラフルな変換をしたかったら yc-use-color を t にする
;;;
;;;  ・間違って確定したら再変換
;;;    間違って確定しても確定直後なら C-j で再変換できる
;;;    カーソルを動かしたりするともう再変換できないけど (T_T)
;;;
;;;  ・全角ひら仮名や全角アルファベットも変換できる
;;;
;;;  ・字種変換も漢字変換候補に含まれる

;;; K  ... 漢字
;;; r  ... romaji
;;; H  ... ひらがな
;;; k  ... カタカナ
;;; h  ... 半角カナ
;;; a  ... alphabet
;;; A  ... ａｌｐｈａｂｅｔ

;;; rK ... romaji-漢字
;;; rH ... romaji-ひらがな
;;; Hk ... ひらがな-カタカナ
;;; Hh ... ひらがな-半角カナ
;;; aA ... alphabet-ａｌｐｈａｂｅｔ
;;; Aa ... ａｌｐｈａｂｅｔ-alphabet

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
  "*かんなのライブラリーパス(default.canna のある場所)を設定する"
  :type 'directory
  :group 'yc)
(defsubst get-yc-canna-lib-path ()
  (condition-case nil
      (file-name-as-directory yc-canna-lib-path)
    (error "")))
(defcustom yc-canna-dic-path
  (concat (get-yc-canna-lib-path) "dic/")
  "*かんなの辞書パス(default.{cpb,kp}のある場所)を設定する"
  :type 'directory
  :group 'yc)
(defcustom yc-icanna-path
  "icanna"
  "*cannaとUNIX domain socket経由で通信するための補助プログラム(icanna)のパスを設定する"
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
  "かんなのローマ字ひら仮名変換テーブルファイル名を変換する")

(defcustom yc-select-count 2
  "*一覧モードになる繰返し数を設定する。デフォルトは3回。
ただし ~/.canna があった場合には、当該ファイルから設定値を読み込む"
  :type 'integer
  :group 'yc)
(defcustom yc-choice-stay nil
  "*一覧モードで変換候補を選択したときに次の文節に進むか、
候補を選択した文節に留まるかを指定する。
指定が nil の場合、文節を進める
指定が 非nil の場合、文節に留まる"
  :type 'boolean
  :group 'yc)
(defvar yc-rK-trans-key "\C-j"
  "*漢字変換キーを設定する")
(defcustom yc-stop-chars "(){}<>"
  "*漢字変換文字列を取り込む時に変換範囲に含めない文字を設定する"
  :type 'string
  :group 'yc)
(defcustom yc-server-host nil
  "*cannaserver が動いているホスト名を指定する。
nil の場合、localhost を指定した事になる"
  :type 'string
  :group 'yc)
(defcustom yc-enable-hankaku t
  "*半角かなを字種変換候補として有効にする。
非nilの場合、半角かな有効。nilの場合、半角かな無効"
  :type 'boolean
  :group 'yc)
(defcustom yc-connect-server-at-startup t
  "*ycを読み込んだらすぐにサーバに接続する。
非nilの場合、すぐ接続する。nilの場合、最初に漢字変換キーを押すまで接続しない。"
  :type 'boolean
  :group 'yc)

;; minibuffer キーバインド
(and (boundp 'minibuffer-local-map) minibuffer-local-map
     (define-key minibuffer-local-map yc-rK-trans-key 'yc-rK-trans))

(defvar yc-mode nil         "漢字変換トグル変数")
(defvar yc-henkan-mode nil  "漢字変換モード変数")
(defvar yc-input-mode nil   "かな入力モード変数")
(defvar yc-edit-mode nil    "かな編集モード変数")
(defvar yc-select-mode nil  "候補一覧モード変数")
(defvar yc-defword-mode nil "単語登録モード変数")
(defvar yc-wclist-mode nil  "漢字選択モード変数")
(or (assq 'yc-mode minor-mode-alist)
    (setq minor-mode-alist (cons '(yc-mode " yc") minor-mode-alist)))

(defvar yc-mode-map (make-sparse-keymap)         "漢字変換トグルマップ")
(defvar yc-henkan-mode-map (make-sparse-keymap)  "漢字変換モードマップ")
(defvar yc-input-mode-map (make-sparse-keymap)   "かな入力モードマップ")
(defvar yc-edit-mode-map (make-sparse-keymap)    "かな編集モードマップ")
(defvar yc-select-mode-map (make-sparse-keymap)  "候補一覧モードマップ")
(defvar yc-defword-mode-map (make-sparse-keymap) "単語登録モードマップ")
(defvar yc-wclist-mode-map (make-sparse-keymap)  "漢字選択モードマップ")
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
;;; isearch 時に boil 出来るようにする
;;;
(defvar yc-isearch nil)
(defun yc-isearch-rK-trans (arg)
  "インクリメンタルサーチ中にANK-漢字変換する関数"
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
  (if (= (length (substring "あ" 1)) 0)
      ;; 文字単位で substring してる
      (progn
	(defun yc-substring (str from &optional to)
	  (if (null (stringp str)) nil
	    (if (= (length str) 0) ""
	      (if (numberp to)
		  (substring str from to)
		(substring str from)))))
	;(defalias 'yc-substring (symbol-function 'substring))
	(defalias 'yc-strlen (symbol-function 'length)) )
    ;; byte 単位で substring してる
    (defun yc-substring (str b &optional e)
      (let ((l (string-to-list str)))
	(concat (if e
		    (yc-subsequence l b e)
		  (nthcdr b l)))))
    (defun yc-strlen (str)
      (length (string-to-list str)))
    (defalias 'string-bytes (symbol-function 'length)) ))

;; カーソル前の文字種を返却する関数
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
  "yc-debug 変数で指定されたバッファに OBJ を表示する。
OBJ を返却する。"
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
  "cannaserver との通信状態が変化したときに動作する関数"
  (when (and (processp yc-server) (eq (process-status yc-server) 'closed))
    (set-process-sentinel yc-server nil))
  (if (waiting-for-user-input-p)
      (put 'yc-server 'init nil)
    (signal 'yc-trap-server-down (list yc-server-host))))

(defun yc-server-open ()
  "cannaserver との通信を開始する関数"
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
;;   "cannaserver との通信を終了する関数"
;;   (set-process-sentinel yc-server nil)
;;   (when (processp yc-server) (delete-process yc-server)))

;; modified 01/12/29 by matz@ruby-lang.org
(defun yc-server-close ()
  "cannaserver との通信を終了する関数"
  (when (processp yc-server)
    (set-process-sentinel yc-server nil)
    (when (processp yc-server) (delete-process yc-server))))

(defun yc-server-check ()
  "cannaserver と通信できるかを確認する関数"
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

;; cannaserver に要求を送信し応答を返却する関数
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

;; cannaserver から応答を蓄積する関数
(defun yc-filter (process response)
  (yc-debug (concat "     << " response))
  (setq yc-res-buffer (concat yc-res-buffer response)))

;; cannaserver からの応答を解析してリストに変換して戻る関数
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

;; cannaserver と CANNA プロトコルをやり取りする関数群
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
;;; 字種変換
;;;

;; default ローマ字-ひら仮名変換テーブル
(defconst yc-default-rH-table
  '(("~" "￣" "") ("}" "』" "") ("|" "｜" "") ("{" "『" "") ("zz" "っ" "z")
    ("zyu" "じゅ" "") ("zyo" "じょ" "") ("zyi" "じぃ" "") ("zye" "じぇ" "")
    ("zya" "じゃ" "") ("zu" "ず" "") ("zo" "ぞ" "") ("zi" "じ" "")
    ("ze" "ぜ" "") ("za" "ざ" "") ("yy" "っ" "y") ("yu" "ゆ" "") ("yo" "よ" "")
    ("yi" "い" "") ("ye" "いぇ" "") ("ya" "や" "") ("xyu" "ゅ" "")
    ("xyo" "ょ" "") ("xya" "ゃ" "") ("xwa" "ゎ" "") ("xu" "ぅ" "")
    ("xtu" "っ" "") ("xtsu" "っ" "") ("xo" "ぉ" "") ("xi" "ぃ" "")
    ("xe" "ぇ" "") ("xa" "ぁ" "") ("'" "’" "") ("\"" "”" "") ("ww" "っ" "w")
    ("wu" "う" "") ("wo" "を" "") ("wi" "ゐ" "") ("we" "ゑ" "") ("wa" "わ" "")
    ("vv" "っ" "v") ("vu" "う゛" "") ("vo" "う゛ぉ" "") ("vi" "う゛ぃ" "")
    ("ve" "う゛ぇ" "") ("va" "う゛ぁ" "") ("u" "う" "") ("tyu" "ちゅ" "")
    ("tyo" "ちょ" "") ("tyi" "ちぃ" "") ("tye" "ちぇ" "") ("tya" "ちゃ" "")
    ("tu" "つ" "") ("tt" "っ" "t") ("tsu" "つ" "") ("tso" "つぉ" "")
    ("tsi" "つぃ" "") ("tse" "つぇ" "") ("tsa" "つぁ" "") ("to" "と" "")
    ("ti" "ち" "") ("thu" "てゅ" "") ("tho" "てょ" "") ("thi" "てぃ" "")
    ("the" "てぇ" "") ("tha" "てゃ" "") ("te" "て" "") ("tch" "っ" "ch")
    ("ta" "た" "") ("syu" "しゅ" "") ("syo" "しょ" "") ("syi" "しぃ" "")
    ("sye" "しぇ" "") ("sya" "しゃ" "") ("su" "す" "") ("ss" "っ" "s")
    ("so" "そ" "") ("si" "し" "") ("shu" "しゅ" "") ("sho" "しょ" "")
    ("shi" "し" "") ("she" "しぇ" "") ("sha" "しゃ" "") ("se" "せ" "")
    ("sa" "さ" "") ("ryu" "りゅ" "") ("ryo" "りょ" "") ("ryi" "りぃ" "")
    ("rye" "りぇ" "") ("rya" "りゃ" "") ("ru" "る" "") ("rr" "っ" "r")
    ("ro" "ろ" "") ("ri" "り" "") ("re" "れ" "") ("ra" "ら" "") ("qq" "っ" "q")
    ("pyu" "ぴゅ" "") ("pyo" "ぴょ" "") ("pyi" "ぴぃ" "") ("pye" "ぴぇ" "")
    ("pya" "ぴゃ" "") ("pu" "ぷ" "") ("pp" "っ" "p") ("po" "ぽ" "")
    ("pi" "ぴ" "") ("pe" "ぺ" "") ("pa" "ぱ" "") ("o" "お" "")
    ("nyu" "にゅ" "") ("nyo" "にょ" "") ("nyi" "にぃ" "") ("nye" "にぇ" "")
    ("nya" "にゃ" "") ("n'" "ん" "") ("nu" "ぬ" "") ("no" "の" "")
    ("nn" "ん" "") ("ni" "に" "") ("ne" "ね" "") ("na" "な" "") ("n" "ん" "")
    ("myu" "みゅ" "") ("myo" "みょ" "") ("myi" "みぃ" "") ("mye" "みぇ" "")
    ("mya" "みゃ" "") ("mu" "む" "") ("mo" "も" "") ("mn" "ん" "")
    ("mm" "っ" "m") ("mi" "み" "") ("me" "め" "") ("ma" "ま" "")
    ("lyu" "りゅ" "") ("lyo" "りょ" "") ("lyi" "りぃ" "") ("lye" "りぇ" "")
    ("lya" "りゃ" "") ("lu" "る" "") ("lo" "ろ" "") ("li" "り" "")
    ("le" "れ" "") ("la" "ら" "") ("kyu" "きゅ" "") ("kyo" "きょ" "")
    ("kyi" "きぃ" "") ("kye" "きぇ" "") ("kya" "きゃ" "") ("ku" "く" "")
    ("ko" "こ" "") ("kk" "っ" "k") ("ki" "き" "") ("ke" "け" "") ("ka" "か" "")
    ("jyu" "じゅ" "") ("jyo" "じょ" "") ("jyi" "じぃ" "") ("jye" "じぇ" "")
    ("jya" "じゃ" "") ("ju" "じゅ" "") ("jo" "じょ" "") ("jj" "っ" "j")
    ("ji" "じ" "") ("je" "じぇ" "") ("ja" "じゃ" "") ("i" "い" "")
    ("hyu" "ひゅ" "") ("hyo" "ひょ" "") ("hyi" "ひぃ" "") ("hye" "ひぇ" "")
    ("hya" "ひゃ" "") ("hu" "ふ" "") ("ho" "ほ" "") ("hi" "ひ" "")
    ("hh" "っ" "h") ("he" "へ" "") ("ha" "は" "") ("gyu" "ぎゅ" "")
    ("gyo" "ぎょ" "") ("gyi" "ぎぃ" "") ("gye" "ぎぇ" "") ("gya" "ぎゃ" "")
    ("gwu" "ぐぅ" "") ("gwo" "ぐぉ" "") ("gwi" "ぐぃ" "") ("gwe" "ぐぇ" "")
    ("gwa" "ぐぁ" "") ("gu" "ぐ" "") ("go" "ご" "") ("gi" "ぎ" "")
    ("gg" "っ" "g") ("ge" "げ" "") ("ga" "が" "") ("fu" "ふ" "")
    ("fo" "ふぉ" "") ("fi" "ふぃ" "") ("ff" "っ" "f") ("fe" "ふぇ" "")
    ("fa" "ふぁ" "") ("e" "え" "") ("dyu" "ぢゅ" "") ("dyo" "ぢょ" "")
    ("dyi" "ぢぃ" "") ("dye" "ぢぇ" "") ("dya" "ぢゃ" "") ("du" "づ" "")
    ("do" "ど" "") ("di" "ぢ" "") ("dhu" "でゅ" "") ("dho" "でょ" "")
    ("dhi" "でぃ" "") ("dhe" "でぇ" "") ("dha" "でゃ" "") ("de" "で" "")
    ("dd" "っ" "d") ("da" "だ" "") ("cyu" "ちゅ" "") ("cyo" "ちょ" "")
    ("cyi" "ちぃ" "") ("cye" "ちぇ" "") ("cya" "ちゃ" "") ("cu" "く" "")
    ("co" "こ" "") ("chu" "ちゅ" "") ("cho" "ちょ" "") ("chi" "ち" "")
    ("che" "ちぇ" "") ("cha" "ちゃ" "") ("cc" "っ" "c") ("ca" "か" "")
    ("byu" "びゅ" "") ("byo" "びょ" "") ("byi" "びぃ" "") ("bye" "びぇ" "")
    ("bya" "びゃ" "") ("bu" "ぶ" "") ("bo" "ぼ" "") ("bi" "び" "")
    ("be" "べ" "") ("bb" "っ" "b") ("ba" "ば" "") ("a" "あ" "") ("`" "｀" "")
    ("_" "＿" "") ("^" "＾" "") ("]" "」" "") ("\\" "￥" "") ("[" "「" "")
    ("@~" "〜" "") ("@}" "｝" "") ("@||" "‖" "") ("@|" "｜" "") ("@{" "｛" "")
    ("@]" "］" "") ("@\\" "＼" "") ("@[" "［" "") ("@@" "　" "")
    ("@568" "たろう88・1" "") ("@3" "…" "") ("@2" "‥" "") ("@/" "・" "")
    ("@." "．" "") ("@-" "−" "") ("@," "，" "") ("@)" "）" "") ("@(" "（" "")
    ("@" "＠" "") ("?" "？" "") (">" "＞" "") ("=" "＝" "") ("<" "＜" "")
    (";" "；" "") (":" "：" "") ("9" "９" "") ("8" "８" "") ("7" "７" "")
    ("6" "６" "") ("5" "５" "") ("4" "４" "") ("3" "３" "") ("2" "２" "")
    ("1" "１" "") ("0" "０" "") ("/" "／" "") ("." "。" "") ("-" "ー" "")
    ("," "、" "") ("+" "＋" "") ("*" "＊" "") ("&" "＆" "") ("%" "％" "")
    ("$" "＄" "") ("#" "＃" "") ("!" "！" "") (" " "　" "")))

;; default ひら仮名-ローマ字変換テーブル
(defconst yc-default-Hr-table 
  '(("っ" . "xtsu")
    ("あ" . "a")  ("い" . "i")  ("う" . "u")  ("え" . "e")  ("お" . "o")
    ("ぁ" . "xa") ("ぃ" . "xi") ("ぅ" . "xu") ("ぇ" . "xe") ("ぉ" . "xo")
    ("ゎ" . "xwa") ("ゃ" . "xya") ("ゅ" . "xyu") ("ょ" . "xyo")
    ("う゛ぁ" . "va") ("う゛ぃ" . "vi") ("う゛" . "vu") ("う゛ぇ" . "ve")
    ("う゛ぉ" . "vo") ("か" . "ka") ("き" . "ki") ("く" . "ku") ("け" . "ke")
    ("こ" . "ko") ("が" . "ga") ("ぎ" . "gi") ("ぐ" . "gu") ("げ" . "ge")
    ("ご" . "go") ("きゃ" . "kya") ("きぃ" . "kyi") ("きゅ" . "kyu")
    ("きぇ" . "kye") ("きょ" . "kyo") ("ぎゃ" . "gya") ("ぎぃ" . "gyi")
    ("ぎゅ" . "gyu") ("ぎぇ" . "gye") ("ぎょ" . "gyo") ("ぐぁ" . "gwa")
    ("ぐぃ" . "gwi") ("ぐぅ" . "gwu") ("ぐぇ" . "gwe") ("ぐぉ" . "gwo")
    ("さ" . "sa") ("し" . "shi") ("す" . "su") ("せ" . "se") ("そ" . "so")
    ("ざ" . "za") ("じ" . "ji") ("ず" . "zu") ("ぜ" . "ze") ("ぞ" . "zo")
    ("しゃ" . "sha") ("しぃ" . "syi") ("しゅ" . "shu") ("しぇ" . "she")
    ("しょ" . "sho") ("じゃ" . "ja") ("じぃ" . "jyi") ("じゅ" . "ju")
    ("じぇ" . "je") ("じょ" . "jo") ("た" . "ta") ("ち" . "ti") ("つ" . "tu")
    ("て" . "te") ("と" . "to") ("だ" . "da") ("ぢ" . "di") ("づ" . "du")
    ("で" . "de") ("ど" . "do") ("ちゃ" . "cha") ("ちぃ" . "cyi")
    ("ちゅ" . "chu") ("ちぇ" . "che") ("ちょ" . "cho") ("ぢゃ" . "dya")
    ("ぢぃ" . "dyi") ("ぢゅ" . "dyu") ("ぢぇ" . "dye") ("ぢょ" . "dyo")
    ("つぁ" . "tsa") ("つぃ" . "tsi") ("つぇ" . "tse") ("つぉ" . "tso")
    ("てゃ" . "tha") ("てぃ" . "thi") ("てゅ" . "thu") ("てぇ" . "the")
    ("てょ" . "tho") ("でゃ" . "dha") ("でぃ" . "dhi") ("でゅ" . "dhu")
    ("でぇ" . "dhe") ("でょ" . "dho") ("な" . "na") ("に" . "ni") ("ぬ" . "nu")
    ("ね" . "ne") ("の" . "no") ("にゃ" . "nya") ("にぃ" . "nyi")
    ("にゅ" . "nyu") ("にぇ" . "nye") ("にょ" . "nyo") ("は" . "ha")
    ("ひ" . "hi") ("ふ" . "fu") ("へ" . "he") ("ほ" . "ho") ("ば" . "ba")
    ("び" . "bi") ("ぶ" . "bu") ("べ" . "be") ("ぼ" . "bo") ("ぱ" . "pa")
    ("ぴ" . "pi") ("ぷ" . "pu") ("ぺ" . "pe") ("ぽ" . "po") ("ひゃ" . "hya")
    ("ひぃ" . "hyi") ("ひゅ" . "hyu") ("ひぇ" . "hye") ("ひょ" . "hyo")
    ("びゃ" . "bya") ("びぃ" . "byi") ("びゅ" . "byu") ("びぇ" . "bye")
    ("びょ" . "byo") ("ぴゃ" . "pya") ("ぴぃ" . "pyi") ("ぴゅ" . "pyu")
    ("ぴぇ" . "pye") ("ぴょ" . "pyo") ("ふぁ" . "fa") ("ふぃ" . "fi")
    ("ふぇ" . "fe") ("ふぉ" . "fo") ("ま" . "ma") ("み" . "mi") ("む" . "mu")
    ("め" . "me") ("も" . "mo") ("みゃ" . "mya") ("みぃ" . "myi")
    ("みゅ" . "myu") ("みぇ" . "mye") ("みょ" . "myo") ("や" . "ya")
    ("ゆ" . "yu") ("いぇ" . "ye") ("よ" . "yo") ("ら" . "ra") ("り" . "ri")
    ("る" . "ru") ("れ" . "re") ("ろ" . "ro") ("りゃ" . "rya") ("りぃ" . "ryi")
    ("りゅ" . "ryu") ("りぇ" . "rye") ("りょ" . "ryo") ("わ" . "wa")
    ("ゐ" . "wi") ("ゑ" . "we") ("を" . "wo") ("ん" . "n'") ("ー" . "-")
    ("「" . "[") ("」" . "]") ("、" . ",") ("。" . ".") ("￥" . "\\")
    ("”" . "\"") ("｀" . "`")))

;; ひらがな-カタカナ変換テーブル 文字列
;(defconst yc-HkST
;  '(("う゛" . "ヴ")))

;; ひらがな-カタカナ変換テーブル 文字
(defconst yc-HkT
  '((?ぁ . ?ァ) (?ぃ . ?ィ) (?ぅ . ?ゥ) (?ぇ . ?ェ) (?ぉ . ?ォ)
    (?あ . ?ア) (?い . ?イ) (?う . ?ウ) (?え . ?エ) (?お . ?オ)
    (?か . ?カ) (?き . ?キ) (?く . ?ク) (?け . ?ケ) (?こ . ?コ)
    (?が . ?ガ) (?ぎ . ?ギ) (?ぐ . ?グ) (?げ . ?ゲ) (?ご . ?ゴ)
    (?さ . ?サ) (?し . ?シ) (?す . ?ス) (?せ . ?セ) (?そ . ?ソ)
    (?ざ . ?ザ) (?じ . ?ジ) (?ず . ?ズ) (?ぜ . ?ゼ) (?ぞ . ?ゾ)
    (?た . ?タ) (?ち . ?チ) (?つ . ?ツ) (?て . ?テ) (?と . ?ト)
                            (?っ . ?ッ)
    (?だ . ?ダ) (?ぢ . ?ヂ) (?づ . ?ヅ) (?で . ?デ) (?ど . ?ド)
    (?な . ?ナ) (?に . ?ニ) (?ぬ . ?ヌ) (?ね . ?ネ) (?の . ?ノ)
    (?は . ?ハ) (?ひ . ?ヒ) (?ふ . ?フ) (?へ . ?ヘ) (?ほ . ?ホ)
    (?ば . ?バ) (?び . ?ビ) (?ぶ . ?ブ) (?べ . ?ベ) (?ぼ . ?ボ)
    (?ぱ . ?パ) (?ぴ . ?ピ) (?ぷ . ?プ) (?ぺ . ?ペ) (?ぽ . ?ポ)
    (?ま . ?マ) (?み . ?ミ) (?む . ?ム) (?め . ?メ) (?も . ?モ)
    (?ゃ . ?ャ)             (?ゅ . ?ュ)             (?ょ . ?ョ)
    (?や . ?ヤ)             (?ゆ . ?ユ)             (?よ . ?ヨ)
    (?ら . ?ラ) (?り . ?リ) (?る . ?ル) (?れ . ?レ) (?ろ . ?ロ)
    (?わ . ?ワ) (?ゐ . ?ヰ)             (?ゑ . ?ヱ) (?を . ?ヲ)
    (?ん . ?ン)))

;; ひらがな-半角カタカナ変換テーブル 文字
(defconst yc-HhT
  '((?ぁ . "ｧ")  (?ぃ . "ｨ")  (?ぅ . "ｩ")  (?ぇ . "ｪ")  (?ぉ . "ｫ")
    (?あ . "ｱ")  (?い . "ｲ")  (?う . "ｳ")  (?え . "ｴ")  (?お . "ｵ")
    (?か . "ｶ")  (?き . "ｷ")  (?く . "ｸ")  (?け . "ｹ")  (?こ . "ｺ")
    (?が . "ｶﾞ") (?ぎ . "ｷﾞ") (?ぐ . "ｸﾞ") (?げ . "ｹﾞ") (?ご . "ｺﾞ")
    (?さ . "ｻ")  (?し . "ｼ")  (?す . "ｽ")  (?せ . "ｾ")  (?そ . "ｿ")
    (?ざ . "ｻﾞ") (?じ . "ｼﾞ") (?ず . "ｽﾞ") (?ぜ . "ｾﾞ") (?ぞ . "ｿﾞ")
    (?た . "ﾀ")  (?ち . "ﾁ")  (?つ . "ﾂ")  (?て . "ﾃ")  (?と . "ﾄ")
                              (?っ . "ｯ")
    (?だ . "ﾀﾞ") (?ぢ . "ﾁﾞ") (?づ . "ﾂﾞ") (?で . "ﾃﾞ") (?ど . "ﾄﾞ")
    (?な . "ﾅ")  (?に . "ﾆ")  (?ぬ . "ﾇ")  (?ね . "ﾈ")  (?の . "ﾉ")
    (?は . "ﾊ")  (?ひ . "ﾋ")  (?ふ . "ﾌ")  (?へ . "ﾍ")  (?ほ . "ﾎ")
    (?ば . "ﾊﾞ") (?び . "ﾋﾞ") (?ぶ . "ﾌﾞ") (?べ . "ﾍﾞ") (?ぼ . "ﾎﾞ")
    (?ぱ . "ﾊﾟ") (?ぴ . "ﾋﾟ") (?ぷ . "ﾌﾟ") (?ぺ . "ﾍﾟ") (?ぽ . "ﾎﾟ")
    (?ま . "ﾏ")  (?み . "ﾐ")  (?む . "ﾑ")  (?め . "ﾒ")  (?も . "ﾓ")
    (?ゃ . "ｬ")               (?ゅ . "ｭ")               (?ょ . "ｮ")
    (?や . "ﾔ")               (?ゆ . "ﾕ")               (?よ . "ﾖ")
    (?ら . "ﾗ")  (?り . "ﾘ")  (?る . "ﾙ")  (?れ . "ﾚ")  (?ろ . "ﾛ")
    (?わ . "ﾜ")  (?ゐ . "ｲ")               (?ゑ . "ｴ")  (?を . "ｦ")
    (?ん . "ﾝ")  (?ー . "ｰ")))

;; 半角-全角変換テーブル
(defconst yc-aAT
  '(;(?ﾞ . ?゛)
    (?! . ?！) (?\" . ?″) (?# . ?＃) (?$ . ?＄) (?% . ?％) (?& . ?＆)
    (?\' . ?’) (?\( . ?（) (?\) . ?）) (?* . ?＊) (?+ . ?＋) (?, . ?，)
    (?- . ?−) (?. . ?．) (?/ . ?／) (?0 . ?０) (?1 . ?１) (?2 . ?２)
    (?3 . ?３) (?4 . ?４) (?5 . ?５) (?6 . ?６) (?7 . ?７) (?8 . ?８)
    (?9 . ?９) (?: . ?：) (?\; . ?；) (?< . ?＜) (?= . ?＝) (?> . ?＞)
    (?? . ?？) (?@ . ?＠) (?A . ?Ａ) (?B . ?Ｂ) (?C . ?Ｃ) (?D . ?Ｄ)
    (?E . ?Ｅ) (?F . ?Ｆ) (?G . ?Ｇ) (?H . ?Ｈ) (?I . ?Ｉ) (?J . ?Ｊ)
    (?K . ?Ｋ) (?L . ?Ｌ) (?M . ?Ｍ) (?N . ?Ｎ) (?O . ?Ｏ) (?P . ?Ｐ)
    (?Q . ?Ｑ) (?R . ?Ｒ) (?S . ?Ｓ) (?T . ?Ｔ) (?U . ?Ｕ) (?V . ?Ｖ)
    (?W . ?Ｗ) (?X . ?Ｘ) (?Y . ?Ｙ) (?Z . ?Ｚ) (?\[ . ?［) (?\\ . ?＼)
    (?\] . ?］) (?^ . ?＾) (?_ . ?＿) (?` . ?‘) (?a . ?ａ) (?b . ?ｂ)
    (?c . ?ｃ) (?d . ?ｄ) (?e . ?ｅ) (?f . ?ｆ) (?g . ?ｇ) (?h . ?ｈ)
    (?i . ?ｉ) (?j . ?ｊ) (?k . ?ｋ) (?l . ?ｌ) (?m . ?ｍ) (?n . ?ｎ)
    (?o . ?ｏ) (?p . ?ｐ) (?q . ?ｑ) (?r . ?ｒ) (?s . ?ｓ) (?t . ?ｔ)
    (?u . ?ｕ) (?v . ?ｖ) (?w . ?ｗ) (?x . ?ｘ) (?y . ?ｙ) (?z . ?ｚ)
    (?{ . ?｛) (?| . ?｜) (?} . ?｝) (?~ . ?￣)))


(defun yc-substitute-string (src dst str)
  (let ((pos 0))
    (while (string-match src str pos)
      (setq pos (+ (match-beginning 0) (length dst))
            str (concat (substring str 0 (match-beginning 0))
			dst
                        (substring str (match-end 0)))))
    str))

;; ひらがな-カタカナ変換
(defun yc-conv-Hk (str)
  (yc-substitute-string
   "ウ゛" "ヴ" 
   (concat (mapcar (lambda (c) (let ((l (assq c yc-HkT))) (if l (cdr l) c)))
		   (append str nil)))))

;; ひらがな-半角カナ変換
(defun yc-conv-Hh (str)
  (mapconcat (lambda (c) (let ((l (assq c yc-HhT)))
			   (if l (cdr l) (char-to-string c))))
	     (append str nil) ""))

;; カタカナ-ひらがな変換
(defun yc-conv-kH (str)
  (concat (mapcar (lambda (c) (let ((l (rassq c yc-HkT))) (if l (car l) c)))
		  (append (yc-substitute-string "ヴ" "ウ゛" str) nil))))

;; alphabet-ａｌｐｈａｂｅｔ変換
(defun yc-conv-aA (str)
  (concat (mapcar (lambda (c) (let ((l (assq c yc-aAT))) (if l (cdr l) c)))
		  (append str nil))))

;; ａｌｐｈａｂｅｔ-alphabet変換
(defun yc-conv-Aa (str)
  (concat (mapcar (lambda (c) (let ((l (rassq c yc-aAT))) (if l (car l) c)))
		  (append str nil))))

;;
;; ひらがな-romaji変換
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
      (cond ((equal (car l) ?っ) (setq roma (cons -2 roma) l (cdr l)))
	    ((equal (car l) ?ん) (setq roma (cons -1 roma) l (cdr l)))
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
    (let ((xtsu (yc-conv-Hr-internal "っ"))
	  (nn (yc-conv-Hr-internal "ん")))
      (while l
	(let ((c (and (car roma) (or (integerp (car roma)) (car roma))
		      (car (string-to-list (car roma))))))
	  (setq roma (cons (cond ((not (integerp (car l))) (car l))
				 ((and (= (car l) -1) ; ん+母音
				       c
				       (memq c '(-1 ?n ?a ?i ?u ?e ?o)))
				  (cdr nn))
				 ((= (car l) -1) "n") ; ん+子音 or 最終
				 ((and (= (car l) -2) ; っ+子音
				       c
				       (not (memq c '(?n ?a ?i ?u ?e ?o))))
				  (char-to-string c))
				 ((= (car l) -2) ; っ+母音 or 最終
				  (cdr xtsu))) roma)
		l (cdr l)))))
    (apply 'concat roma)))

;;
;; romaji-ひらがな変換
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
      ;; nlst が list もしくは nil の時
      (let ((a (assq (string-to-char seq) nlst)) ; nlst に存在するかの check
	    (n nlst)			; nlst に存在したときの存在部分以降
	    (m nil))			; nlst に存在したときの存在部分以前
	(if a
	    (progn
	      (while (and (car n) (not (eq (caar n) (string-to-char seq))))
		(setq m (append m (list (car n)))
		     n (cdr n)))
	      (if (= (length seq) 1)
		  ;; nlst に存在し seq が 1 文字
		  (append m
			  (list (append (list (caar n))
					(list (cons nil str)) (cdar n)))
			  (cdr n))
		;; nlst に存在し seq が 2 文字以上
		(append m
			(list (append
			       (list (string-to-char seq))
			       (yc-make-entry
				(yc-substring seq 1) str (cdar n))))
			(cdr n))))
	  (if (= (length seq) 1)
	      ;; nlst に存在せず 1 文字
	      (append nlst (list (cons (string-to-char seq) str)))
	    ;; nlst に存在せず 2 文字以上
	    (append nlst
		    (list (append (list (string-to-char seq))
				  (yc-make-entry
				   (yc-substring seq 1) str nil)))))))
    (if (= (length seq) 1)
	;; nlst が listp でなく 1 文字
	(list (cons nil nlst) (cons (string-to-char seq) str))
      ;; nlst が listp でなく 2 文字以上
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

;; flag が t の時
;; カーソル直前とfence 終端の n を変換しない
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
;; 辞書の設定とローマ字漢字変換テーブルの設定を有効にする
;; 一覧モードになる回数を有効にする

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


;; 初期化関数
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

;; cannaserver の通信初期化関数
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

;; 終了時関数
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
(defvar yc-fence-yomi nil)		; 変換読み
(defvar yc-fence-start nil)		; fence 始端位置
(defvar yc-fence-end nil)		; fence 終端位置
(defvar yc-henkan-separeter " ")	; fence mode separeter
(defvar yc-henkan-buffer nil)		; 表示用バッファ
(defvar yc-henkan-length nil)		; 表示用バッファ長
(defvar yc-henkan-revpos nil)		; 文節始端位置
(defvar yc-henkan-revlen nil)		; 文節長

;;; yc basic local
(defvar yc-mark nil)			; 文節番号
(defvar yc-mark-list nil)		; 文節候補番号 
(defvar yc-mark-max nil)		; 文節候補数
(defvar yc-henkan-list nil)		; 文節リスト
(defvar yc-kouho-list nil)		; 文節候補リスト
(defvar yc-repeat 0)			; 繰り返し回数

;;
(defvar yc-selected-window nil)		; minibuffer退避用リスト
(defvar yc-select-markers nil)		; minibuffer候補リストmarkers

(defvar yc-bunsetsu-yomi-list nil)

;; 指定文節の読みを返す関数
;; force が 非nil の場合、強制的に cannaserver から読みを取得する
;; 読みを取得した文節はその読みをキャッシュする
(defun yc-get-bunsetsu-yomi (idx &optional force)
  (or (and (not force)
	   (nth idx yc-bunsetsu-yomi-list))
      (yc-get-yomi (yc-get conv) idx 4096)))

;; 指定文節の読みを設定する関数
;; cut が 非nil の場合、指定文節以降の読みを削除する
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

;; 指定文節の読みを返す関数
;; 文節を指定しない場合、現在の文節が対象となる
;; 読みを取得した文節はその読みをキャッシュする
;; cut が 非nil の場合、指定文節以降の読みを削除する
(defun yc-yomi (&optional idx &optional cut)
  (if (integerp idx)
      (yc-put-bunsetsu-yomi idx (yc-get-bunsetsu-yomi idx cut) cut)
    (yc-put-bunsetsu-yomi yc-mark (yc-get-bunsetsu-yomi yc-mark cut) cut)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; undo 情報の制御 と yc で未定義なキーのチェックアウト
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; yc-henkan-mode & yc-select-mode キーバインド
;; command 実行前に command をチェックして
;; yc で定義していない command を実行しようとしたら
;; 変換を確定するようにする
(defun yc-pre-command-function ()
  (when (and (or yc-henkan-mode yc-edit-mode)
	     (not (string-match "^yc-" (symbol-name this-command))))
    (if yc-edit-mode
	(yc-edit-kakutei)
      (when yc-select-mode (yc-choice))
      (yc-kakutei))))

;; undo buffer 退避用変数
(defvar yc-buffer-undo-list nil)
(make-variable-buffer-local 'yc-buffer-undo-list)
(defvar yc-buffer-modified-p nil)
(make-variable-buffer-local 'yc-buffer-modified-p)

(defvar yc-blink-cursor nil)
(defvar yc-cursor-type nil)
;; undo buffer を退避し、undo 情報の蓄積を停止する関数
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

;; 退避した undo buffer を復帰し、undo 情報の蓄積を再開する関数
(defun yc-enable-undo ()
  (remove-hook 'pre-command-hook 'yc-pre-command-function)
  (when (not yc-buffer-modified-p) (set-buffer-modified-p nil))
  (setq buffer-undo-list yc-buffer-undo-list)
  (when (fboundp 'blink-cursor-mode)
    (blink-cursor-mode (if yc-blink-cursor 1 -1)))
  (when (boundp 'cursor-type) (setq cursor-type yc-cursor-type)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 表示系関数群
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

;; fence を表示するモード
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

  ;; 一覧モード関連
  (if (not yc-select-mode)
      (yc-delete-overlay yc-select-current)
    (yc-set-overlay-select)
    (select-window (car yc-selected-window)))

  ;; 変換モードと入力モード関連
  (when (or yc-fence-mode yc-henkan-mode)
    (when (not (eq yc-fence-start yc-fence-end))
      (delete-region yc-fence-start yc-fence-end))
    (goto-char yc-fence-start))

  ;; fenceの切替え
  (if (setq yc-fence-mode arg)
      (yc-disable-undo)
    (yc-enable-undo)
    (yc-delete-overlay yc-fence)
    (yc-delete-overlay yc-current))

  ;; fenceの表示
  (when yc-fence-mode

    ;; 変換/編集文字列を挿入
    (when yc-use-fence
      (insert "||")
      (set-marker yc-fence-end (point))
      (backward-char))
    (insert yc-henkan-buffer)
    (unless yc-use-fence
      (set-marker yc-fence-end (point)))

    ;; fence に色を付ける
    (yc-set-overlay-fence)
    (goto-char (+ (if yc-use-fence 1 0)
		  yc-fence-start
		  (if yc-henkan-mode yc-henkan-revpos (yc-yomi-point))))
    (when yc-henkan-mode
      (yc-set-overlay-current))
;    (goto-char (1- (point)))
;    (print last-command-event)	; DEBUG
    (when yc-select-mode (select-window (minibuffer-window)))))

;; yc の関数郡から呼び出され表示を司る関数
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
;; 登録モード & 一覧モード共通関数
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
;; 記号選択モード
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 記号選択モードは逐一に一覧リストを生成する
;; 記号の一覧モードを静的に持つのは空間の無駄だし
;; 記号の一覧表を作るのは時間の無駄だから
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

;; 記号選択モード時のコマンドチェック関数
;; 記号モード用に定義したコマンド以外のコマンドが
;; 入力された場合には記号選択モードを抜けて
;; 入力されたコマンドを実行する
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
;; 登録モード
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

;;; 登録用変数
;; Canna v3.5
;; 名詞[#T35]		する[#T30]、な[#T15]、する&な[#T10]
;; 固有名詞[#KK]	人名[#JN]、地名[#CN]、人名&地名[#JCN]
;; 動詞[#G5]		い(名詞)[#G5r]... 他にもいろいろある main.code
;;                      動詞は終止形(う段で終るはず)のみ登録可能とし
;;                      最後の一文字で活用行(「あ行」とか「か行」)を判断する
;; 形容詞[#KT]		(名詞)[#KTY]
;; 形容動詞[#T18]	する[#T13]、(名詞)[#T15]、する&(名詞)[#T10]
;; 副詞[#F14]		する[#F12]、と[#F06]、する&と[#F04]
;; その他[#KJ]
(defvar yc-defword-mark nil)
(defvar yc-defword-yomi nil)
(defvar yc-defword-word nil)
(defvar yc-hinshi-list
  '("人名" "地名" "人名&地名" "固有名詞" "名詞" "その他"))
(defvar yc-hinshi-item
  '(("人名" . "#JN") ("地名" . "#CN") ("人名&地名" . "#JCN")
    ("固有名詞" . "#KK") ("名詞" . "#T35") ("さ変名詞" . "#T30")
    ("形容詞活用名詞" . "#T15") ("さ変&形容詞活用名詞" . "#T10")
    ("その他" . "#KJ")))

;; 登録時の選択品詞候補を minibuffer に表示する用意をする関数
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

;; 単語を実際に登録する関数
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

;; リージョンの単語を辞書に登録する関数
(defun yc-touroku-region (b e)
  "指定された region を辞書登録する"
  (interactive "r")
  (setq yc-defword-word (buffer-substring b e))
  (setq yc-defword-yomi
	(read-from-minibuffer (concat "単語[" yc-defword-word "] 読み? ")
			      nil yc-defword-minibuffer-map))
  (or (string= yc-defword-yomi "")
      (yc-make-touroku-buffer))
  (yc-color-touroku))
  
;; 品詞選択時に次候補に移動する関数
(defun yc-defword-forward ()
  "辞書登録中の品詞選択時に次の品詞に移動する"
  (interactive)
  (setq yc-defword-mark (1+ yc-defword-mark))
  (when (<= (length yc-select-markers) yc-defword-mark)
    (setq yc-defword-mark 0))
  (goto-char (nth yc-defword-mark yc-select-markers))
  (yc-color-touroku))

;; 品詞選択時に前候補に移動する関数
(defun yc-defword-backward ()
  "辞書登録中の品詞選択時に前の品詞に移動する"
  (interactive)
  (setq yc-defword-mark (1- yc-defword-mark))
  (when (> 0 yc-defword-mark)
    (setq yc-defword-mark (1- (length yc-select-markers))))
  (goto-char (nth yc-defword-mark yc-select-markers))
  (yc-color-touroku))

;; 品詞選択時に先頭品詞に移動する関数
(defun yc-defword-beginning-of-line ()
  "辞書登録時の品詞選択時に先頭の品詞に移動する"
  (interactive)
  (setq yc-defword-mark 0)
  (goto-char (nth yc-defword-mark yc-select-markers))
  (yc-color-touroku))

;; 品詞選択時に最終品詞に移動する関数
(defun yc-defword-end-of-line ()
  "辞書登録時の品詞選択時に最終の品詞に移動する"
  (interactive)
  (setq yc-defword-mark (1- (length yc-select-markers)))
  (goto-char (nth yc-defword-mark yc-select-markers))
  (yc-color-touroku))

;; 登録を中止する関数
(defun yc-defword-cancel ()
  "辞書登録を中止する"
  (interactive)
  (when (yc-overlayp yc-select-current) (yc-delete-overlay yc-select-current))
  (setq yc-defword-mode nil)
  (yc-delete-select-buffer))
(defun yc-defword-cancel-and-self-insert ()
  (interactive)
  (yc-defword-cancel)
  (setq unread-command-events (list last-command-event)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 一覧モード
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

;; 一覧モードを開始する関数
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

;; 一覧モードで次候補に移動する関数
(defun yc-select-forward ()
  "一覧モードで次の候補に移動する"
  (interactive)
  (yc-next-kouho)
  (yc-post-command-function))

;; 一覧モードで前候補に移動する関数
(defun yc-select-backward ()
  "一覧モードで前の候補に移動する"
  (interactive)
  (yc-prev-kouho)
  (yc-post-command-function))

;; 一覧モードで次行の候補に移動する関数
(defun yc-select-next ()
  "一覧モードで次行の候補に移動する"
  (interactive)
  (yc-next-kouho)
  (goto-char (nth (nth yc-mark yc-mark-list) yc-select-markers))
  (while (not (bolp))
    (yc-next-kouho)
    (goto-char (nth (nth yc-mark yc-mark-list) yc-select-markers)))
  (yc-post-command-function))

;; 一覧モードで前行の候補に移動する関数
(defun yc-select-previous ()
  "一覧モードで前行の候補に移動する"
  (interactive)
  (yc-select-beginning-of-line)
  (yc-select-backward)
  (yc-select-beginning-of-line))

;; 一覧モードで見えている候補群の先頭に移動する関数
(defun yc-select-beginning-of-line ()
  "一覧モードで行頭の候補に移動する"
  (interactive)
  (while (not (bolp))
    (yc-prev-kouho)
    (goto-char (nth (nth yc-mark yc-mark-list) yc-select-markers)))
  (yc-post-command-function))

;; 一覧モードで見えている候補群の末尾に移動する関数
(defun yc-select-end-of-line ()
  "一覧モードで行末の候補に移動する"
  (interactive)
  (yc-select-next)
  (yc-select-backward))

;; 一覧モードで文節を伸ばす関数
;; 一覧モードは抜ける
(defun yc-select-nobasi ()
  "一覧モードで対象文節長を伸ばす。
副作用として一覧モードは抜ける"
  (interactive)
  (yc-select-cancel)
  (setq unread-command-events (list last-command-event)))

;; 一覧モードで文節を縮める関数
;; 一覧モードは抜ける
(defun yc-select-tidime ()
  "一覧モードで対象文節長を縮める。
副作用として一覧モードは抜ける"
  (interactive)
  (yc-select-cancel)
  (setq unread-command-events (list last-command-event)))

;; 一覧モードで候補を選択する内部関数
(defun yc-choice-internal ()
  (setq yc-select-mode nil)
  (yc-delete-select-buffer))

;; 一覧モードで候補を選択する関数
;; 当然、一覧モードは抜ける
(defun yc-choice ()
  "一覧モードで候補を選択する。
一覧モードは抜ける"
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

;; 一覧モードで候補を選択し、かつ、変換を確定し入力されたキーを再入力する関数
;; 一覧モードおよび変換モードを抜ける
(defun yc-choice-and-self-insert (arg)
  "一覧モードで候補を選択し一覧モードを抜けた後で、
変換を確定し、入力された文字を入力する"
  (interactive "P")
  (yc-choice)
  (yc-kakutei)
  (setq unread-command-events (list last-command-event)))

;; 一覧モードで候補を選択し、かつ、変換を確定し、
;; 確定した文字列を辞書登録する関数
;; 一覧モードおよび変換モードを抜ける
(defun yc-choice-and-touroku ()
  "一覧モードで候補を選択し一覧モードを抜けた後で、変換を確定する"
  (interactive)
  (yc-choice)
  (yc-kakutei)
  (yc-touroku-region yc-fence-start yc-fence-end))

;; 一覧モードを中止する関数
;; 当然一覧モードは抜ける
(defun yc-select-cancel ()
  "一覧モードを中止する"
  (interactive)
  (yc-choice-internal)
  (setcar (nthcdr yc-mark yc-mark-list) 0)
  (setcar (nthcdr yc-mark yc-henkan-list)
	  (nth (nth yc-mark yc-mark-list) yc-kouho-list))
  (yc-post-command-function))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 読み入力＆読み編集モード
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; fence モード用変数
; yc-fence-yomi にキー入力したローマ字を格納している 
(defvar yc-hiragana-list nil)
(defvar yc-romaji-list nil)
(defvar yc-yomi-string-point nil)
(defvar yc-yomi-list-point nil)

;; 読みの設定を初期化する
(defun yc-yomi-reset ()
  (setq yc-fence-yomi ""
	yc-hiragana-list nil
	yc-romaji-list nil
	yc-yomi-string-point 0
	yc-yomi-list-point 0))

;; 読みを入力する
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

;; 読みを削除する
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

;; 読みを終端まで削除する
(defun yc-yomi-kill ()
  (setq yc-romaji-list (yc-generate-romaji-list yc-fence-yomi))
  (setq yc-romaji-list
	(yc-subsequence yc-romaji-list 0 yc-yomi-list-point)
	yc-hiragana-list
	(yc-subsequence yc-hiragana-list 0 yc-yomi-list-point)
	yc-fence-yomi (apply 'concat yc-romaji-list)))

;; 前の読みに移動
(defun yc-yomi-prev ()
  (setq yc-yomi-list-point (1- yc-yomi-list-point))
  (if (< yc-yomi-list-point 0)
      (setq yc-yomi-list-point 0)
    (setq yc-yomi-string-point
	  (- yc-yomi-string-point
	     (yc-strlen (nth yc-yomi-list-point yc-romaji-list))))))

;; 次の読みに移動
(defun yc-yomi-next ()
  (setq yc-yomi-list-point (1+ yc-yomi-list-point))
  (if (> yc-yomi-list-point (length yc-hiragana-list))
      (setq yc-yomi-list-point (length yc-hiragana-list))
    (setq yc-yomi-string-point
	  (+ yc-yomi-string-point
	     (yc-strlen (nth (1- yc-yomi-list-point) yc-romaji-list))))))

;; 最初の読みに移動
(defun yc-yomi-bob ()
  (setq yc-yomi-string-point 0
	yc-yomi-list-point 0))

;; 最後の読みに移動
(defun yc-yomi-eob ()
  (setq yc-yomi-string-point (length yc-fence-yomi)
;	yc-yomi-list-point (length yc-romaji-list)))
	yc-yomi-list-point (length yc-hiragana-list)))

;; ひら仮名読み文字列を返す
(defun yc-yomi-hiragana ()
  (apply 'concat yc-hiragana-list))

;; ひら仮名読み文字列のカーソル位置を返す
(defun yc-yomi-point ()
  (yc-strlen
   (apply 'concat (yc-subsequence yc-hiragana-list 0 yc-yomi-list-point))))

;; 読み編集中のキーの入力処理
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

;; 読み編集中の表示関数
(defun yc-edit-post-command-function ()
  (setq yc-henkan-list (list (yc-yomi-hiragana)))
;  (prin1 yc-fence-yomi)
;  (prin1 yc-romaji-list)
  (yc-post-command-function))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ひら仮名編集モード
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

;; 読み文字列を変換する
(defun yc-edit-henkan ()
  "読み編集中にひら仮名-漢字変換する"
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

;; 編集中に字種変換する
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

;; カタカナに字種変換する
(defun yc-edit-katakana ()
  "読み編集中にカタカナ変換する"
  (interactive)
  (yc-edit-jisyu 'yc-katakana))

;; alphabetに字種変換する
(defun yc-edit-alphabet ()
  "読み編集中にalphabet変換する"
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

;; 最初の読みに移動する
(defun yc-edit-beginning-of-fence ()
  "読み編集中に最初の読みに移動する"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-bob)
  (yc-edit-post-command-function))

;; 最後の読みに移動する
(defun yc-edit-end-of-fence ()
  "読み編集中に最後の読みに移動する"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-eob)
  (yc-edit-post-command-function))

;; 次の読みに移動する
(defun yc-edit-forward-char ()
  "読み編集中に次の読みに移動する"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-next)
  (yc-edit-post-command-function))

;; 前の読みに移動する
(defun yc-edit-backward-char ()
  "読み編集中に前の読みに移動する"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-prev)
  (yc-edit-post-command-function))

;; 前の読みを削除する
(defun yc-edit-backward-delete-char ()
  "読み編集中に前の読みを削除する"
  (interactive)
  (yc-yomi-prev)
  (yc-yomi-delete)
  (if (string= yc-fence-yomi "")
      (yc-edit-cancel)
    (yc-edit-post-command-function)))

;; カーソルのある読みを削除する
(defun yc-edit-delete-char ()
  "読み編集中に現在の読みを削除する"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-delete)
  (if (string= yc-fence-yomi "")
      (yc-edit-cancel)
    (yc-edit-post-command-function)))

;; カーソルのある読みから最後の読みまで削除する
(defun yc-edit-kill-line ()
  "読み編集中に現在の読みから最後の読みまで削除する"
  (interactive)
  (yc-yomi-post-insert)
  (yc-yomi-kill)
  (if (string= yc-fence-yomi "")
      (yc-edit-cancel)
    (yc-edit-post-command-function)))

;; 読みの編集の取り消す
(defun yc-edit-cancel ()
  "読みの編集を取り止める"
  (interactive)
  (yc-yomi-reset)
  (yc-fence-mode nil)
  (setq yc-edit-mode nil
	yc-fence-yomi nil
	yc-henkan-list nil
	yc-fence-start nil
	yc-fence-end nil))

;; 読みの編集を終り、読み文字列をそのまま確定する
(defun yc-edit-kakutei ()
  "読みをそのまま確定する"
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

;; 読み編集中のキー入力
(defun yc-edit-self-insert ()
  "読みを入力する"
  (interactive)
  (yc-self-insert-internal))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ひら仮名入力モード
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
  (setq current-input-method-title "あ")
  (yc-open)
  (remove-hook 'input-method-activate-hook 'yc-input-mode-function))

(defun yc-input-mode (arg)
  "読み編集モード。
入力されたローマ字をひら仮名に変換しながら入力するモード。"
  (interactive "P")
    (when (not (local-variable-p 'yc-input-mode (current-buffer)))
      (make-local-variable 'yc-input-mode))
    (setq yc-input-mode (if (null arg) (not yc-input-mode)
			  (> (prefix-numeric-value arg) 0)))
    (if yc-input-mode
	(progn
	  (setq inactivate-current-input-method-function 'yc-inactivate)
	  (setq current-input-method-title "あ")
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
  "読みの入力。
入力されたローマ字をひら仮名に変換しながら読みを入力する。"
  (interactive)
  (when yc-henkan-mode (yc-kakutei))
  (yc-yomi-reset)
  (setq yc-edit-mode t
	yc-mark 0
	yc-fence-start (copy-marker (point-marker))
	yc-fence-end (copy-marker (point-marker)))
  (yc-self-insert-internal))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 変換モード
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

;; cannaserver から変換候補を取得する関数
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

;; 次の候補を選択する関数
(defun yc-next-kouho ()
  (setcar (nthcdr yc-mark yc-mark-list) (1+ (nth yc-mark yc-mark-list)))
  (when (<= (length yc-kouho-list) (nth yc-mark yc-mark-list))
    (setcar (nthcdr yc-mark yc-mark-list) 0))
  (if (car yc-symbol-list)
      (setcdr (car yc-symbol-list) (if (>= (nth yc-mark yc-mark-list)
					   (nth yc-mark yc-mark-max))
				       (- (nth yc-mark yc-mark-list)
					  (nth yc-mark yc-mark-max))))))

;; 直前の候補を選択する関数
(defun yc-prev-kouho ()
  (setcar (nthcdr yc-mark yc-mark-list) (1- (nth yc-mark yc-mark-list)))
  (when (> 0 (nth yc-mark yc-mark-list))
    (setcar (nthcdr yc-mark yc-mark-list) (1- (length yc-kouho-list))))
  (if (car yc-symbol-list)
      (setcdr (car yc-symbol-list) (if (> (nth yc-mark yc-mark-list)
					  (nth yc-mark yc-mark-max))
				       (- (nth yc-mark yc-mark-list)
					  (nth yc-mark yc-mark-max))))))

;; 次の文節を選択する関数
(defun yc-forward-bunsetsu (&optional arg)
  (if arg
      (setq yc-mark arg)
    (setq yc-mark (1+ yc-mark))
    (when (>= yc-mark (length yc-henkan-list))
      (setq yc-mark 0)))
  (yc-yomi yc-mark)
  (setq yc-kouho-list nil))

;; 直前の文節を選択する関数
(defun yc-backward-bunsetsu (&optional arg)
  (if arg
      (setq yc-mark arg)
    (setq yc-mark (1- yc-mark))
    (when (> 0 yc-mark)
      (setq yc-mark (1- (length yc-henkan-list)))))
  (yc-yomi yc-mark)
  (setq yc-kouho-list nil))

;; 現在の文節の alphabet を取り出す関数
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


;; 一覧モードに依存せずに次候補を選択する内部関数
(defun yc-modeless-next-internal ()
  (cond (yc-henkan-mode (yc-get-kouho-list)
			(yc-next-kouho))
	(yc-select-mode (yc-select-forward))))

;; 一覧モードに依存せずに前候補を選択する内部関数
(defun yc-modeless-previous-internal ()
  (cond (yc-henkan-mode (yc-get-kouho-list)
			(yc-prev-kouho))
	(yc-select-mode (yc-select-backward))))

;; 字種変換リストを作成する
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

;; 字種変換処理
(defun yc-jisyu (arg)
  (yc-get-kouho-list)
  (setcar (nthcdr yc-mark yc-mark-list)
	  (cond ((eq arg 'hiragana) (1- (length yc-kouho-list)))
		((eq arg 'katakana) (- (length yc-kouho-list) 2))
		((eq arg 'hankaku)  (- (length yc-kouho-list) 3))
		((eq arg 'alpha2)   (- (length yc-kouho-list) 4))
		((eq arg 'alpha)    (- (length yc-kouho-list) 5)))))

;; 字種変換を行う内部関数
(defun yc-jisyu-henkan-internal ()
  (cond ((= (mod yc-repeat 5) 0) (yc-jisyu 'hiragana)) ; ひらがな
	((= (mod yc-repeat 5) 1) (yc-jisyu 'katakana)) ; カタカナ
	((= (mod yc-repeat 5) 2) (yc-jisyu 'hankaku)) ; 半角カナ
	((= (mod yc-repeat 5) 3) (yc-jisyu 'alpha2)) ; ａｌｐｈａｂｅｔ
	((= (mod yc-repeat 5) 4) (yc-jisyu 'alpha)))) ; alphabet


;; リージョンをローマ字漢字変換する関数
;; ひらがな漢字変換も可能
(defun yc-henkan-region (b e)
  "指定された region を漢字変換する"
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

;; 変換を確定する関数
(defun yc-kakutei ()
  "漢字変換を確定する"
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
  "viper-mode を使用中で minibuffer で確定を入力されたときの関数。
変換文字列を確定するだけで minibuffer を抜けない。"
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

;; 変換中の文字列を確定し確定した文字列を辞書登録する
(defun yc-kakutei-and-touroku ()
  "漢字変換を確定し、変換中だった文字列を辞書登録する"
  (interactive)
  (yc-kakutei)
  (yc-touroku-region yc-fence-start yc-fence-end))

;; 変換を確定し入力されたキーを再入力する関数
(defun yc-kakutei-and-self-insert (arg)
  "漢字変換を確定し、入力された文字を入力する"
  (interactive "P")
  (yc-kakutei)
  (setq unread-command-events (list last-command-event)))

;; 変換を取り消す関数
;; 変換前の状態に戻す
(defun yc-cancel ()
  "漢字変換を中止し、変換前の状態に戻す"
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

;; 変換中の文節長を変更する関数
(defun yc-resize-bunsetsu (arg)
  (let* ((len (if (< arg 0)
		  (let ((pos (string-match
			      "う゛$" (or (nth yc-mark yc-henkan-list) ""))))
		    (cond ((not pos) -2)
			  ((> pos 0)
			   (- (yc-strlen (nth yc-mark yc-henkan-list)) 2))
			  (t 0)))
		(cond ((eq (nth (1+ yc-mark) yc-henkan-list) nil) 0)
		      ((eq (string-match
			    "^う゛" (nth (1+ yc-mark) yc-henkan-list)) 0)
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

;; 変換中の文節を伸ばす関数
(defun yc-enlarge ()
  "変換文節を拡張する"
  (interactive)
  (condition-case err
      (yc-resize-bunsetsu 1)
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; 変換中の文節を縮める関数
(defun yc-shrink ()
  "変換中の文節を縮小する"
  (interactive)
  (condition-case err
      (yc-resize-bunsetsu -1)
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; 一覧モードにかかわらず候補を選択する関数
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

;; 一覧モードに関わらず次候補を選択する関数
(defun yc-modeless-next ()
  "一覧モードに関わらず次候補を選択する"
  (interactive)
  (yc-modeless-kouho 'yc-modeless-next-internal))

;; 一覧モードに関わらず前候補を選択する関数
(defun yc-modeless-previous ()
  "一覧モードに関わらず前候補を選択する"
  (interactive)
  (yc-modeless-kouho 'yc-modeless-previous-internal))

;; 字種変換をサイクリックに行う関数
(defun yc-jisyu-lotate (key)
  (when yc-select-mode (yc-select-cancel))
  (setq yc-repeat (if (eq last-command this-command) (1+ yc-repeat) key))
  (yc-jisyu-henkan-internal)
  (yc-post-command-function))

;; 一覧モードに関わらず字種変換を行う関数
(defun yc-jisyu-henkan ()
  "一覧モードに関わらず字種変換を行う"
  (interactive)
  (yc-jisyu-lotate 0))

;; ひらがな変換を行う関数
(defun yc-hiragana ()
  "一覧モードに関わらず字種変換をする。
ひらがな→カタカナ→半角カナ→ａｌｐｈａｂｅｔ→alphabet
の順にループする"
  (interactive)
  (yc-jisyu-lotate 0))

;; カタカナ変換を行う関数
(defun yc-katakana ()
  "一覧モードに関わらず字種変換をする。
カタカナ→半角カナ→ａｌｐｈａｂｅｔ→alphabet→ひらがな
の順にループする"
  (interactive)
  (yc-jisyu-lotate 1))

;; 半角カナ変換を行う関数
(defun yc-hankaku ()
  "一覧モードに関わらず字種変換をする。
半角カナ→ａｌｐｈａｂｅｔ→alphabet→ひらがな→カタカナ
の順にループする"
  (interactive)
  (yc-jisyu-lotate 2))

;; ａｌｐｈａｂｅｔ変換を行う関数
(defun yc-alphabet2 ()
  "一覧モードに関わらず字種変換をする。
ａｌｐｈａｂｅｔ→alphabet→ひらがな→カタカナ→半角カナ
の順にループする"
  (interactive)
  (yc-jisyu-lotate 3))

;; alphabet変換を行う関数
(defun yc-alphabet ()
  "一覧モードに関わらず字種変換をする。
alphabet→ひらがな→カタカナ→半角カナ→ａｌｐｈａｂｅｔ
の順にループする"
  (interactive)
  (yc-jisyu-lotate 4))

;; 次候補を選択する関数(一覧モードでは使えない)
(defun yc-next ()
  "次候補を選択する"
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

;; 前候補を選択する関数(一覧モードでは使えない)
(defun yc-previous ()
  "前候補を選択する"
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

;; 次文節を選択する関数(一覧モードでは使えない)
(defun yc-forward ()
  "次文節に対象文節を移動する"
  (interactive)
  (condition-case err
      (progn
	(yc-forward-bunsetsu)
	(yc-post-command-function))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; 前文節を選択する関数(一覧モードでは使えない)
(defun yc-backward ()
  "前文節に対象文節を移動する"
  (interactive)
  (condition-case err
      (progn
	(yc-backward-bunsetsu)
	(yc-post-command-function))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; 先頭文節を選択する関数(一覧モードでは使えない)
(defun yc-beginning-of-fence ()
  "先頭文節に対象文節を移動する"
  (interactive)
  (condition-case err
      (progn
	(yc-backward-bunsetsu 0)
	(yc-post-command-function))
    (yc-trap-server-down
     (beep)
     (message (error-message-string err))
     (yc-cancel))))

;; 最終文節を選択する関数(一覧モードでは使えない)
(defun yc-end-of-fence ()
  "最終文節に対象文節を移動する"
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

;; ローマ字漢字変換時、対象とするローマ字を設定するための変数
(defvar yc-skip-chars nil)

;; yc-mode の状態変更関数
;;  正の引数の場合、常に yc-mode を開始する
;;  {負,0}の引数の場合、常に yc-mode を終了する
;;  引数無しの場合、yc-mode をトグルする

;; buffer 毎に yc-mode を変更する
(defun yc-mode (&optional arg)
  "YC mode は ローマ字から直接漢字変換するための minor mode です。
引数に正数を指定した場合は、YC mode を有効にします。

YC モードが有効になっている場合 \\<yc-mode-map>\\[yc-rK-trans] で
point から行頭方向に同種の文字列が続く間を漢字変換します。

同種の文字列とは以下のものを指します。
・半角カタカナとyc-stop-chars に指定した文字を除く半角文字
・漢字を除く全角文字"
  (interactive "P")
  (yc-mode-internal arg nil))

;; 全バッファで yc-mode を変更する
(defun global-yc-mode (&optional arg)
  "YC mode は ローマ字から直接漢字変換するための minor mode です。
引数に正数を指定した場合は、YC mode を有効にします。

YC モードが有効になっている場合 \\<yc-mode-map>\\[yc-rK-trans] で
point から行頭方向に同種の文字列が続く間を漢字変換します。

同種の文字列とは以下のものを指します。
・半角カタカナとyc-stop-chars に指定した文字を除く半角文字
・漢字を除く全角文字"
  (interactive "P")
  (yc-mode-internal arg t))

;; yc-mode を変更する共通関数
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

;; buffer local な yc-mode を削除する関数
(defun yc-kill-yc-mode ()
  (let ((buf (buffer-list)))
    (while buf
      (set-buffer (car buf))
      (kill-local-variable 'yc-mode)
      (setq buf (cdr buf)))))

;; ローマ字漢字変換対象となる alphabet 列を設定する
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

;; ローマ字漢字変換関数
(defun yc-rK-trans ()
  "ローマ字漢字変換をする。

以下の順序に処理を振り分ける。

・変換を確定した直後の場合、確定したばかりの文字列を再変換する。
・カーソルから行頭方向にローマ字列が続く範囲でローマ字漢字変換を行う。
・カーソルから行頭方向に「ひらがな」あるいは「カタカナ」
  または「全角英数記号」が続く範囲で漢字変換を行う。
・変換中は次候補となる。"
  (interactive)
;  (print last-command)			; DEBUG
  (cond

   (yc-henkan-mode
    ;; 変換中に呼ばれたら yc-henkan-mode-map に定義されている関数を呼ぶ
    (setq yc-repeat (if (eq last-command 'yc-rK-trans) (1+ yc-repeat) 0))
    (funcall (lookup-key yc-henkan-mode-map yc-rK-trans-key))
    (if (and (not yc-select-mode) (>= yc-repeat yc-select-count))
	(yc-select)
      (yc-post-command-function)))

   ((or (eq last-command 'yc-kakutei)
	(eq last-command 'yc-cancel))	; reconversion after yc-cancel
    ;; 確定直後に呼ばれたら再変換
    (delete-region yc-fence-start yc-fence-end)
    (insert yc-fence-yomi)
    (set-marker yc-fence-end (point))
    (yc-henkan-region yc-fence-start yc-fence-end))

   (t
    ;; 上記以外で呼ばれたら新規変換
    (setq yc-repeat 0)
    (cond

     ((eq (yc-char-charset (preceding-char)) 'ascii)
      ;; カーソル直前が alphabet だったら
      (let ((end (point))
	    (gap (yc-skip-chars-backward)))
	(goto-char end)
	(when (/= gap 0)
	  (setq yc-fence-yomi (buffer-substring (+ end gap) end))
	  (if (not (string= yc-fence-yomi ""))
	      (setq yc-henkan-mode t))
	  (yc-henkan-region (+ end gap) end))))

     ((yc-nkanji (preceding-char))
      ;; カーソル直前が 全角で漢字以外 だったら
      (let ((end (point))
	    (start (let* ((pos (or (and (mark-marker)
					(marker-position (mark-marker))) 1))
			  (mark-check (>= pos (point))))
		     (while (and (or mark-check (< pos (point)))
				 (yc-nkanji (preceding-char)))
		       (backward-char))
		     (point))))
	(yc-henkan-region start end) ))))))

;; 全角で漢字以外の判定関数
(defun yc-nkanji (ch)
  (and (eq (yc-char-charset ch) 'japanese-jisx0208)
       (not (string-match "[亜-瑤]" (char-to-string ch)))))

;; ローマ字漢字変換時、変換対象とするローマ字を読み飛ばす関数
(defun yc-skip-chars-backward ()
  (let ((pos (or (and (markerp (mark-marker)) (marker-position (mark-marker)))
		 1)))
    (skip-chars-backward yc-skip-chars (and (< pos (point)) pos))))

;; ローマ字-平仮名-カタカナ変換
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
    (yc-hiragana) ; yc-hiragana を呼ぶたびに字種変換する
    (yc-kakutei-internal))

   (t
    ;; 上記以外で呼ばれたら新規変換
    (setq yc-repeat 0)
    (cond
     ((eq (yc-char-charset (preceding-char)) 'ascii)
      ;; カーソル直前が alphabet だったら
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
      ;; カーソル直前が 全角で漢字以外だったら
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

;; input method 対応
(defun yc-activate (&rest arg)
  (yc-input-mode 1))
(defun yc-inactivate (&rest arg)
  (yc-input-mode -1))
(register-input-method
 "japanese-yc" "Japanese" 'yc-activate
 "あ" "Romaji -> Hiragana -> Kanji&Kana"
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
