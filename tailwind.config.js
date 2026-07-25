/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  darkMode: 'class', // preparado para modo oscuro futuro, no activo en el MVP
  theme: {
    extend: {
      colors: {
        ink: {
          DEFAULT: '#22252B',
          soft: '#454A54',
        },
        paper: {
          DEFAULT: '#FBF9F5',
          muted: '#F1EDE4',
        },
        brass: {
          DEFAULT: '#B08D57',
          light: '#D8C39C',
          dark: '#8A6D3F',
        },
        sage: {
          DEFAULT: '#7C8B75',
          light: '#A9B6A2',
        },
        rust: {
          DEFAULT: '#B5533C',
          light: '#D98066',
        },
      },
      fontFamily: {
        display: ['"Fraunces"', 'serif'],
        body: ['"IBM Plex Sans"', 'sans-serif'],
      },
      borderRadius: {
        sm: '4px',
        md: '8px',
        lg: '14px',
      },
    },
  },
  plugins: [],
}
