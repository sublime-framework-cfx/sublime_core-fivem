//import { ModalsProviderProps } from './config/modals';
import { MantineTransition } from '@mantine/core';

export interface Option {
  type: string;
  label: string;
  name?: string;
  checked?: boolean;
  description?: string;
  required?: boolean;
  default?: string | boolean | Date | number | Array<any>;
  format?: string;
  icon?: string | string[];
  placeholder?: string;
  max?: number;
  min?: number;
  step?: number;
  data?: any;
  size?: string;
  error?: string;
  callback?: boolean;
  options?: SelectProps;
  transition?: {name: MantineTransition, duration: number, timingFunction: string};
}

export interface ModalPropsCustom {
  title: string;
  size?: string;
  options: Option[];
  useCallback?: boolean;
  canCancel?: boolean;
  transition?: {name: MantineTransition, duration: number, timingFunction: string};
}

export interface SelectProps {
  Array: {label: string, value: string}[];
}

// _components

export interface _SelectProps {
  index: string;
  label?: string;
  defaultValue?: number;
  min?: number;
  max?: number;
  step?: number;
  transition?: {name: MantineTransition, duration: number, timingFunction: string}
  onChanged: (
    index: string,
    value: number,
    isRequired?: boolean,
    callback?: boolean
  ) => void;
  props: any;
}

/*interface Data {
  max?: number;
  min?: number;
  required?: boolean;
  placeholder?: string;
  description?: string;
  label?: string;
  type?: string;
  name?: string;
  value?: string;
  step?: number;
  callback?: boolean;
  options?: SelectProps;
}

interface SelectProps {
  Array: {label: string, value: string}[];
}*/