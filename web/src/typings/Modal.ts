import { ModalsProviderProps } from './config/modals';

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
}

export interface ModalPropsCustom {
  title: string;
  size?: string;
  options: Option[];
  useCallback?: boolean;
}

export interface SelectProps {
  Array: {label: string, value: string}[];
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