interface Data {
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
}

interface SelectProps {
  Array: {label: string, value: string}[];
}