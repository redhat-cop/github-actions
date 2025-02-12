const globals = require("globals");
const js = require("@eslint/js");

const {
    FlatCompat,
} = require("@eslint/eslintrc");

const compat = new FlatCompat({
    baseDirectory: __dirname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all
});

module.exports = [...compat.extends("eslint:recommended", "prettier"), {
    languageOptions: {
        globals: {
            ...globals.node,
            ...globals.commonjs,
        },

        ecmaVersion: "latest",
        sourceType: "commonjs",
    },

    rules: {},
}];
