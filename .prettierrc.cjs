const base = require('@discourse/lint-configs/prettier');

/** @type {import("prettier").Config} */
module.exports = {
	...base,

	// Ensure the plugins CI uses are loaded here too
	plugins: [
		...(base.plugins || []),
		'prettier-plugin-ember-template-tag',
		'prettier-plugin-tailwindcss', // keep Tailwind last
	],

	// Make .gjs/.gts files use the template-tag parser
	overrides: [...(base.overrides || []), { files: ['*.gjs', '*.gts'], options: { parser: 'ember-template-tag' } }],
};
