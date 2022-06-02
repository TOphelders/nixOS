args@{ config, lib, pkgs, ... }:

with lib;
with types;
let

  makeFtPlugins = ftplugins: with attrsets;
    mapAttrs'
      (key: value: nameValuePair "nvim/after/ftplugin/${key}.vim" ({ text = value; }))
      ftplugins;

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
        TagbarOpen
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
        TagbarOpen
      '';
      javascriptreact = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        TagbarOpen
      '';
      typescript = ''
        setl formatexpr=
        setl formatprg=prettier\ --parser\ typescript\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        TagbarOpen
      '';
      typescriptreact = ''
        setl formatexpr=
        setl formatprg=prettier\ --parser\ typescript\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
        setl makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        TagbarOpen
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
        TagbarOpen
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

    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      withPython3 = true;

      coc.enable = true;
      coc.settings = {
        "preferences.colorSupport" = true;
        "diagnostics.enable" = false;
        "rust-client.disableRustup" = true;
      };

      extraConfig = ''
        set foldmethod=indent
        set laststatus=2
        set foldlevelstart=99
        set termguicolors
        set mouse=n

        "Better searching
        set hlsearch
        set ignorecase
        set smartcase
        nnoremap <silent><CR> :noh<CR><CR>
        nmap <silent> gd <Plug>(coc-definition)

        " Use K to show documentation in preview window
        nnoremap <silent> K :call <SID>show_documentation()<CR>

        function! s:show_documentation()
          if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
          else
            call CocAction('doHover')
          endif
        endfunction

        "Line display
        set number
        set ruler

        "Term specific settings
        autocmd TermOpen * setlocal nonumber norelativenumber

        "Copy paste
        set clipboard=unnamed

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

        "Delete buffers without closing window
        command! Bd bp|bd #

        "Nvim Tree
        autocmd VimEnter * NvimTreeOpen
        autocmd VimEnter * wincmd p
        nmap <F6> :NvimTreeToggle<CR>

        "Tagbar
        nmap <F7> :TagbarToggle<CR>
        let g:tagbar_type_typescriptreact = {
          \ 'kinds': [
            \ 'c:class',
            \ 'n:namespace',
            \ 'f:function',
            \ 'G:generator',
            \ 'v:variable',
            \ 'm:method',
            \ 'p:property',
            \ 'i:interface',
            \ 'g:enum',
            \ 't:type',
            \ 'a:alias',
          \ ],
          \'sro': '.',
            \ 'kind2scope' : {
            \ 'c' : 'class',
            \ 'n' : 'namespace',
            \ 'i' : 'interface',
            \ 'f' : 'function',
            \ 'G' : 'generator',
            \ 'm' : 'method',
            \ 'p' : 'property',
            \},
        \ }

        "Airline
        let g:airline_powerline_fonts = 1
        let g:airline#extensions#coc#enabled = 1
        let g:airline#extensions#coc#show_coc_status = 1

        "Bufferline Mapping
        "These commands will navigate through buffers in order regardless of which mode you are using
        "e.g. if you change the order of buffers :bnext and :bprevious will not respect the custom ordering
        nnoremap <silent>[b :BufferLineCycleNext<CR>
        nnoremap <silent>b] :BufferLineCyclePrev<CR>

        "These commands will sort buffers by directory, language, or a custom criteria
        nnoremap <silent>be :BufferLineSortByExtension<CR>
        nnoremap <silent>bd :BufferLineSortByDirectory<CR>

        "Coc Settings
        command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

        "Lua Config
        lua <<EOF

        -- Nvim Tree
        require'nvim-tree'.setup {
          view = {
            width = 45,
          },
          update_focused_file = {
            enable = true,
            update_cwd = false,
            ignore_list = {},
          },
        }

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
        require'bufferline'.setup {
          options = {
            mode = "buffers",
            close_command = "bdelete! %d",
            right_mouse_command = nil,
            left_mouse_command = "buffer %d",
            middle_mouse_command = "bdelete! %d",

            color_icons = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_buffer_default_icon = true,
            show_close_icon = true,
            separator_style = "padded_slant",

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
        nvim-tree-lua
        tagbar

        # Git
        coc-git
        vim-fugitive

        # Syntax
        (nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars))
        coc-eslint
        coc-highlight
        coc-tsserver
        coc-rls
        coc-pairs
        coc-prettier
      ];
    };
  };
}
