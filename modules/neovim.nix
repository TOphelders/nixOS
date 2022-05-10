args@{ config, lib, pkgs, ... }:

with lib;
with types;
let

  makeFtPlugins = ftplugins: with attrsets;
    mapAttrs'
      (key: value: nameValuePair "nvim/after/ftplugin/${key}.vim" ({ text = value; }))
      ftplugins;

  cocConfig = {
    "coc.preferences.colorSupport" = true;
  };

in
{
  config = {
    xdg.configFile = makeFtPlugins {
      xml = ''
        setl formatprg=prettier\ --stdin-filepath\ %";
      '';
      sh = ''
        setl makeprg=shellcheck\ -f\ gcc\ %
      '';
      rust = ''
        setl formatprg=rustfmt
        setl makeprg=cargo\ check
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      json = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      yaml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      javascript = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      typescript = ''
        setl formatexpr=
        setl formatprg=prettier\ --parser\ typescript\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      css = ''
        setl formatprg=prettier\ --parser\ css\ --stdin-filepath\ %
      '';
      scss = ''
        setl formatprg=prettier\ --parser\ scss\ --stdin-filepath\ %
      '';
      nix = ''
        setl formatprg=nixpkgs-fmt
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      make = ''
        setl noexpandtab
      '';
      python = ''
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      sql = ''
        setl formatprg=${pkgs.pgformatter}/bin/pg_format
      '';
      haskell = ''
        setl formatprg=ormolu
      '';
      markdown = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
    };

    # xdg.configFile."nvim/coc-settings.json".source = pkgs.writeTextFile {
    #   name = "coc-settings.json";
    #   text = (builtins.toJSON cocConfig);
    # };

    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      withPython3 = true;

      extraConfig = ''
        set foldmethod=indent
        set laststatus=2
        set foldlevelstart=99
        set termguicolors

        "Better searching
        set hlsearch
        set ignorecase
        set smartcase
        nnoremap <silent><CR> :noh<CR><CR>

        "NERDTree config
        nmap <F6> :NERDTreeToggle<CR>

        "Line display
        set number
        set ruler

        "Tab completion
        set wildmenu
        set wildmode=longest:full,full

        "Highlight colours
        highlight Visual guifg=NONE guibg=blue
        highlight Pmenu guibg=black guifg=magenta
        highlight PmenuSel guibg=black guifg=white gui=underline
        highlight SignColumn guibg=none
        highlight CocUnderline gui=underline
        highlight Conceal guifg=none gui=underline,bold,italic guibg=none

        "Indent/word wrap settings
        set shiftwidth=2
        set tabstop=2
        set autoindent
        set expandtab
        set showbreak=↪

        " Statuslilne
        set statusline+=\ %f\ %m%=\ %y\ %q\ %3l:%2c\ \|%3p%%\ 
        
        " Bufferline Mapping
        " These commands will navigate through buffers in order regardless of which mode you are using
        " e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
        nnoremap <silent>[b :BufferLineCycleNext<CR>
        nnoremap <silent>b] :BufferLineCyclePrev<CR>

        " These commands will sort buffers by directory, language, or a custom criteria
        nnoremap <silent>be :BufferLineSortByExtension<CR>
        nnoremap <silent>bd :BufferLineSortByDirectory<CR>

        "Lua Config
        lua <<EOF

        -- Treesitter
        require'nvim-treesitter.configs'.setup {
          highlight = {
            enable = true,
            disable = {"haskell","nix"},
          },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = "gnn",
              node_incremental = "grn",
              scope_incremental = "grc",
              node_decremental = "grm",
            },
          },
          indent = {
            enable = true,
            disable = {"haskell","nix"},
          }
        }

        -- Bufferline
        require("bufferline").setup{
          options = {
            mode = "buffers",
            close_command = "bdelete! %d",
            right_mouse_command = nil,
            left_mouse_command = "buffer %d",
            middle_mouse_command = "bdelete! %d",

            color_icons = true,
            show_buffer_close_icons = true,
            show_buffer_default_icon = true,
            show_close_icon = true,
            separator_style = "slant",

            diagnostics = "coc",

            -- buffer_id | ordinal
            numbers = function(opts)
              return string.format('%s|%s', opts.id, opts.raise(opts.ordinal))
            end,

            offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
              }
            }
          }
        }

        EOF
      '';

      plugins = with pkgs.vimPlugins; [
        # Syntax
        haskell-vim
        rust-vim
        typescript-vim
        vim-javascript
        vim-jsx-pretty
        vim-jsx-typescript
        vim-nix

        # Statusline
        vim-airline

        # Buffers
        bufferline-nvim

        # File Searching
        ctrlp-vim
        nerdtree

        # Syntax
        (nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars))
        coc-nvim
        coc-tsserver
        coc-highlight
      ];
    };
  };
}
