{ pkgs, pkgsMaster, ... }:

let

  # nix-prefetch-url --unpack https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz
  # repo = pkgs.fetchFromGitHub {
  #   owner = "nix-community";
  #   repo = "nix-doom-emacs";
  #   rev = "master";
  #   sha256 = "16f571gd1jja3nqffzqnf0b4w3n907n1k01sl3sd8dl7c37p601p";
  # };

  # doom-emacs = pkgs.callPackage (import repo) {
  #   doomPrivateDir = ./config/doom;
  # };

in
{
  programs.emacs = {
    enable = true;
    package = pkgsMaster.emacs29-nox.pkgs.withPackages (epkgs: [
      epkgs.vterm
    ]);
  };

  home.packages = [
    pkgs.cmake
    pkgs.fd
    pkgs.fontconfig
    pkgs.ripgrep
  ];

  xdg.configFile."doom/config.el".text = ''
    ;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

    ;; Place your private configuration here! Remember, you do not need to run 'doom
    ;; sync' after modifying this file!


    ;; Some functionality uses this to identify you, e.g. GPG configuration, email
    ;; clients, file templates and snippets. It is optional.
    (setq user-full-name "Trevor Ophelders"
          user-mail-address "t.ophelders@gmail.com")

    ;; Doom exposes five (optional) variables for controlling fonts in Doom:
    ;;
    ;; - `doom-font' -- the primary font to use
    ;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
    ;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
    ;;   presentations or streaming.
    ;; - `doom-unicode-font' -- for unicode glyphs
    ;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
    ;;
    ;; See 'C-h v doom-font' for documentation and more examples of what they
    ;; accept. For example:
    ;;
    ;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
    ;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
    ;;
    ;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
    ;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
    ;; refresh your font settings. If Emacs still can't find your font, it likely
    ;; wasn't installed correctly. Font issues are rarely Doom issues!

    ;; There are two ways to load a theme. Both assume the theme is installed and
    ;; available. You can either set `doom-theme' or manually load a theme with the
    ;; `load-theme' function. This is the default:
    (setq doom-theme 'doom-horizon)

    ;; This determines the style of line numbers in effect. If set to `nil', line
    ;; numbers are disabled. For relative line numbers, set this to `relative'.
    (setq display-line-numbers-type t)

    ;; If you use `org' and don't want your org files in the default location below,
    ;; change `org-directory'. It must be set before org loads!
    (setq org-directory "~/org/")


    ;; Whenever you reconfigure a package, make sure to wrap your config in an
    ;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
    ;;
    ;;   (after! PACKAGE
    ;;     (setq x y))
    ;;
    ;; The exceptions to this rule:
    ;;
    ;;   - Setting file/directory variables (like `org-directory')
    ;;   - Setting variables which explicitly tell you to set them before their
    ;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
    ;;   - Setting doom variables (which start with 'doom-' or '+').
    ;;
    ;; Here are some additional functions/macros that will help you configure Doom.
    ;;
    ;; - `load!' for loading external *.el files relative to this one
    ;; - `use-package!' for configuring packages
    ;; - `after!' for running code after a package has loaded
    ;; - `add-load-path!' for adding directories to the `load-path', relative to
    ;;   this file. Emacs searches the `load-path' when you load packages with
    ;;   `require' or `use-package'.
    ;; - `map!' for binding new keys
    ;;
    ;; To get information about any of these functions/macros, move the cursor over
    ;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
    ;; This will open documentation for it, including demos of how they are used.
    ;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
    ;; etc).
    ;;
    ;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
    ;; they are implemented.

    ;; Splash screen
    (setq inhibit-splash-screen t)
    (setq inhibit-startup-message t)

    ;; Tabline
    (after! centaur-tabs (centaur-tabs-group-by-projectile-project))

    ;; Projects
    (setq projectile-track-known-projects-automatically nil)
    (setq projectile-project-search-path '("~/src"))

    ;; Enable word wrap everywhere
    (+global-word-wrap-mode +1)

    ;; Icons in terminal
    (use-package treemacs-nerd-icons
      :config
      (treemacs-load-theme "nerd-icons"))
    (setq doom-themes-treemacs-theme "nerd-icons")

    ;; copilot
    ;; accept completion from copilot and fallback to company
    (use-package! copilot
      :hook (prog-mode . copilot-mode)
      :bind (:map copilot-completion-map
                  ("M-y" . 'copilot-accept-completion)
                  ("M-u" . 'copilot-accept-completion-by-word)))
  '';

  xdg.configFile."doom/init.el".text = ''
    ;;; init.el -*- lexical-binding: t; -*-

    ;; This file controls what Doom modules are enabled and what order they load
    ;; in. Remember to run 'doom sync' after modifying it!

    ;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
    ;;      documentation. There you'll find a link to Doom's Module Index where all
    ;;      of our modules are listed, including what flags they support.

    ;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
    ;;      'C-c c k' for non-vim users) to view its documentation. This works on
    ;;      flags as well (those symbols that start with a plus).
    ;;
    ;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
    ;;      directory (for easy access to its source code).

    (doom! :input
           ;;bidi              ; (tfel ot) thgir etirw uoy gnipleh
           ;;chinese
           ;;japanese
           ;;layout            ; auie,ctsrnm is the superior home row

           :completion
           company           ; the ultimate code completion backend
           ;;helm              ; the *other* search engine for love and life
           ;;ido               ; the other *other* search engine...
           ;;ivy               ; a search engine for love and life
           vertico           ; the search engine of the future

           :ui
           ;;deft              ; notational velocity for Emacs
           doom              ; what makes DOOM look the way it does
           ;;doom-dashboard    ; a nifty splash screen for Emacs
           ;;doom-quit         ; DOOM quit-message prompts when you quit Emacs
           ;;(emoji +unicode)  ; 🙂
           hl-todo           ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
           ;;hydra
           indent-guides     ; highlighted indent columns
           ;;ligatures         ; ligatures and symbols to make your code pretty again
           ;;minimap           ; show a map of the code on the side
           modeline          ; snazzy, Atom-inspired modeline, plus API
           ;;nav-flash         ; blink cursor line after big motions
           ;;neotree           ; a project drawer, like NERDTree for vim
           ophints           ; highlight the region an operation acts on
           (popup +defaults)   ; tame sudden yet inevitable temporary windows
           tabs              ; a tab bar for Emacs
           treemacs          ; a project drawer, like neotree but cooler
           ;;unicode           ; extended unicode support for various languages
           (vc-gutter +pretty) ; vcs diff in the fringe
           vi-tilde-fringe   ; fringe tildes to mark beyond EOB
           ;;window-select     ; visually switch windows
           workspaces        ; tab emulation, persistence & separate workspaces
           ;;zen               ; distraction-free coding or writing

           :editor
           (evil +everywhere); come to the dark side, we have cookies
           file-templates    ; auto-snippets for empty files
           fold              ; (nigh) universal code folding
           ;;(format +onsave)  ; automated prettiness
           ;;god               ; run Emacs commands without modifier keys
           ;;lispy             ; vim for lisp, for people who don't like vim
           ;;multiple-cursors  ; editing in many places at once
           ;;objed             ; text object editing for the innocent
           ;;parinfer          ; turn lisp into python, sort of
           ;;rotate-text       ; cycle region at point between text candidates
           snippets          ; my elves. They type so I don't have to
           word-wrap         ; soft wrapping with language-aware indent

           :emacs
           dired             ; making dired pretty [functional]
           electric          ; smarter, keyword-based electric-indent
           ;;ibuffer         ; interactive buffer management
           undo              ; persistent, smarter undo for your inevitable mistakes
           vc                ; version-control and Emacs, sitting in a tree

           :term
           eshell            ; the elisp shell that works everywhere
           ;;shell             ; simple shell REPL for Emacs
           ;;term              ; basic terminal emulator for Emacs
           vterm             ; the best terminal emulation in Emacs

           :checkers
           syntax              ; tasing you for every semicolon you forget
           (spell +flyspell) ; tasing you for misspelling mispelling
           ;;grammar           ; tasing grammar mistake every you make

           :tools
           ;;ansible
           ;;biblio            ; Writes a PhD for you (citation needed)
           ;;debugger          ; FIXME stepping through code, to help you add bugs
           ;;direnv
           ;;docker
           ;;editorconfig      ; let someone else argue about tabs vs spaces
           ;;ein               ; tame Jupyter notebooks with emacs
           (eval +overlay)     ; run code, run (also, repls)
           ;;gist              ; interacting with github gists
           lookup              ; navigate your code and its documentation
           lsp               ; M-x vscode
           magit             ; a git porcelain for Emacs
           ;;make              ; run make tasks from Emacs
           ;;pass              ; password manager for nerds
           ;;pdf               ; pdf enhancements
           ;;prodigy           ; FIXME managing external services & code builders
           ;;rgb               ; creating color strings
           ;;taskrunner        ; taskrunner for all your projects
           ;;terraform         ; infrastructure as code
           ;;tmux              ; an API for interacting with tmux
           ;;tree-sitter       ; syntax and parsing, sitting in a tree...
           ;;upload            ; map local to remote projects via ssh/ftp

           :os
           (:if IS-MAC macos)  ; improve compatibility with macOS
           ;;tty               ; improve the terminal Emacs experience

           :lang
           ;;agda              ; types of types of types of types...
           ;;beancount         ; mind the GAAP
           ;;(cc +lsp)         ; C > C++ == 1
           ;;clojure           ; java with a lisp
           ;;common-lisp       ; if you've seen one lisp, you've seen them all
           ;;coq               ; proofs-as-programs
           ;;crystal           ; ruby at the speed of c
           ;;csharp            ; unity, .NET, and mono shenanigans
           ;;data              ; config/data formats
           ;;(dart +flutter)   ; paint ui and not much else
           ;;dhall
           ;;elixir            ; erlang done right
           ;;elm               ; care for a cup of TEA?
           emacs-lisp        ; drown in parentheses
           ;;erlang            ; an elegant language for a more civilized age
           ;;ess               ; emacs speaks statistics
           ;;factor
           ;;faust             ; dsp, but you get to keep your soul
           ;;fortran           ; in FORTRAN, GOD is REAL (unless declared INTEGER)
           ;;fsharp            ; ML stands for Microsoft's Language
           ;;fstar             ; (dependent) types and (monadic) effects and Z3
           ;;gdscript          ; the language you waited for
           ;;(go +lsp)         ; the hipster dialect
           ;;(graphql +lsp)    ; Give queries a REST
           ;;(haskell +lsp)    ; a language that's lazier than I am
           ;;hy                ; readability of scheme w/ speed of python
           ;;idris             ; a language you can depend on
           json              ; At least it ain't XML
           ;;(java +lsp)       ; the poster child for carpal tunnel syndrome
           (javascript +lsp)        ; all(hope(abandon(ye(who(enter(here))))))
           ;;julia             ; a better, faster MATLAB
           ;;kotlin            ; a better, slicker Java(Script)
           ;;latex             ; writing papers in Emacs has never been so fun
           ;;lean              ; for folks with too much to prove
           ;;ledger            ; be audit you can be
           ;;lua               ; one-based indices? one-based indices
           markdown          ; writing docs for people to ignore
           ;;nim               ; python + lisp at the speed of c
           ;;nix               ; I hereby declare "nix geht mehr!"
           ;;ocaml             ; an objective camel
           org               ; organize your plain life in plain text
           ;;php               ; perl's insecure younger brother
           ;;plantuml          ; diagrams for confusing people more
           ;;purescript        ; javascript, but functional
           ;;python            ; beautiful is better than ugly
           ;;qt                ; the 'cutest' gui framework ever
           ;;racket            ; a DSL for DSLs
           ;;raku              ; the artist formerly known as perl6
           ;;rest              ; Emacs as a REST client
           ;;rst               ; ReST in peace
           ;;(ruby +rails +lsp +rbenv +rvm)     ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
           (rust +lsp)       ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
           ;;scala             ; java, but good
           ;;(scheme +guile)   ; a fully conniving family of lisps
           sh                ; she sells {ba,z,fi}sh shells on the C xor
           ;;sml
           ;;solidity          ; do you need a blockchain? No.
           ;;swift             ; who asked for emoji variables?
           ;;terra             ; Earth and Moon in alignment for performance.
           ;;web               ; the tubes
           yaml              ; JSON, but readable
           ;;zig               ; C, but simpler

           :email
           ;;(mu4e +org +gmail)
           ;;notmuch
           ;;(wanderlust +gmail)

           :app
           ;;calendar
           ;;emms
           ;;everywhere        ; *leave* Emacs!? You must be joking
           ;;irc               ; how neckbeards socialize
           ;;(rss +org)        ; emacs as an RSS reader
           ;;twitter           ; twitter client https://twitter.com/vnought

           :config
           ;;literate
           (default +bindings +smartparens))
  '';

  xdg.configFile."doom/packages.el".text = ''
    ;; -*- no-byte-compile: t; -*-
    ;;; $DOOMDIR/packages.el
    
    ;; To install a package with Doom you must declare them here and run 'doom sync'
    ;; on the command line, then restart Emacs for the changes to take effect -- or
    ;; use 'M-x doom/reload'.
    
    
    ;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
    ;(package! some-package)
    
    ;; To install a package directly from a remote git repo, you must specify a
    ;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
    ;; https://github.com/radian-software/straight.el#the-recipe-format
    ;(package! another-package
    ;  :recipe (:host github :repo "username/repo"))
    
    ;; If the package you are trying to install does not contain a PACKAGENAME.el
    ;; file, or is located in a subdirectory of the repo, you'll need to specify
    ;; `:files' in the `:recipe':
    ;(package! this-package
    ;  :recipe (:host github :repo "username/repo"
    ;           :files ("some-file.el" "src/lisp/*.el")))
    
    ;; If you'd like to disable a package included with Doom, you can do so here
    ;; with the `:disable' property:
    ;(package! builtin-package :disable t)
    
    ;; You can override the recipe of a built in package without having to specify
    ;; all the properties for `:recipe'. These will inherit the rest of its recipe
    ;; from Doom or MELPA/ELPA/Emacsmirror:
    ;(package! builtin-package :recipe (:nonrecursive t))
    ;(package! builtin-package-2 :recipe (:repo "myfork/package"))
    
    ;; Specify a `:branch' to install a package from a particular branch or tag.
    ;; This is required for some packages whose default branch isn't 'master' (which
    ;; our package manager can't deal with; see radian-software/straight.el#279)
    ;(package! builtin-package :recipe (:branch "develop"))
    
    ;; Use `:pin' to specify a particular commit to install.
    ;(package! builtin-package :pin "1a2b3c4d5e")
    
    
    ;; Doom's packages are pinned to a specific commit and updated from release to
    ;; release. The `unpin!' macro allows you to unpin single packages...
    ;(unpin! pinned-package)
    ;; ...or multiple packages
    ;(unpin! pinned-package another-pinned-package)
    ;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
    ;(unpin! t)

    (package! nerd-icons)
    (package! treemacs-nerd-icons)

    (package! copilot
      :recipe (:host github :repo "zerolfx/copilot.el" :files ("*.el" "dist")))
  '';
}
