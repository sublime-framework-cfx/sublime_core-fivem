import { MantineThemeOverride, rem } from '@mantine/core';



export const themeOverride: MantineThemeOverride = {
  fontFamily: 'Ubuntu',
  primaryColor: 'teal',
 /* globalStyles: (theme) => ({
    "*:hover": {
      outline: 'none',
      color: theme.colors.teal[5],
    },
  }),*/
  /*globalStyles: (theme) => ({
    '*:hover': {
      outline: 'none',
      color: theme.colors.teal[5],
    },
  }),*/
  /*activeStyles: {
    color: 'teal',
    backgroundColor: 'teal',
    borderColor: 'teal',
  },*/
  focusRingStyles: {
    resetStyles: () => ({ outline: 'none' }),
    styles: (theme) => ({ outline: `${rem(2)} solid ${theme.colors.teal[5]}`}),
    inputStyles: (theme) => ({ outline: `${rem(2)} solid ${theme.colors.teal[5]}` }),
  },
  components: {
    Checkbox: {
      defaultProps: {
        color: 'teal.6',
      },
    },
    Switch: {
      defaultProps: {
        color: 'teal.6',
      },
    },
  }
};