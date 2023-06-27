
local null_ls = require("null-ls")
local helpers = require("null-ls.helpers")

-- Configuração do Prettier
local prettier = {
    method = null_ls.methods.FORMATTING,
    filetypes = { "vue", "javascript", "typescript", "javascript.jsx", "typescript.tsx", "html", "css" },
    generator = null_ls.generator({
        command = "prettier",
        -- Você pode adicionar outras opções do Prettier aqui, se necessário
        args = { "--stdin-filepath", "$FILENAME" },
        to_stdin = true,
        from_stdin = true,
        format = "raw",
    }),
}

null_ls.register(prettier)

-- Configuração do Markdownlint
local markdownlint = {
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = { "markdown" },
    generator = null_ls.generator({
        command = "markdownlint",
        args = { "--stdin" },
        to_stdin = true,
        from_stderr = true,
        format = "line",
        check_exit_code = function(code, stderr)
            local success = code <= 1

            if not success then
                print(stderr)
            end

            return success
        end,
        on_output = helpers.diagnostics.from_patterns({
            {
                pattern = [[:(%d+):(%d+) [%w-/]+ (.*)]],
                groups = { "row", "col", "message" },
            },
            {
                pattern = [[:(%d+) [%w-/]+ (.*)]],
                groups = { "row", "message" },
            },
        }),
    }),
}

null_ls.register(markdownlint)

