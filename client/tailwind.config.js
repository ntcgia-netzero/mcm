/** @type {import('tailwindcss').Config} */
module.exports = {
    // NOTE: Update this to include the paths to all files that contain Nativewind classes.
	content: ["./app/**/*.{js,jsx,ts,tsx}", "./components/**/*.{js,jsx,ts,tsx}"],
    presets: [require("nativewind/preset")],
    theme: {
        extend: {
            // TODO: screens，先做小型手機，字體不夠大再調整斷點
            colors: {
                primary: "#448fda",
            },
        },
    },
    plugins: [],
}