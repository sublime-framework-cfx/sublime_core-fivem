import { debugData } from '../../../utils/debugData';
import type { ModalPropsCustom, Option } from '../../../typings';
const modalOptions = [
  { type: 'input', name: 'inputField', label: 'Input Field', required: true, callback: true, error: 'Message perso' },
  { type: 'select', name: 'selectField', label: 'Select Field', options: 
  [
    { value: 'react', label: 'React' },
    { value: 'ng', label: 'Angular' },
    { value: 'svelte', label: 'Svelte' },
    { value: 'vue', label: 'Vue' }
  ], required: true, error: 'Select an option' },
  {
    type: 'checkbox',
    name: 'checkboxField',
    label: 'Checkbox Field',
    //checked: true,
    required: true,
    error: 'Message ??',
  },/*
  {
    type: 'password',
    name: 'inputField',
    label: 'Input Field',
    required: true,
  },
  {
    type: 'slider',
    name: 'sliderField',
    label: 'Slider Field',
    min: 120,
    max: 240,
    default: 180,
  },*/
  {
    type: 'date',
    label: 'Date Input Field',
    required: true
  }
];

export const debugModalsCustom = () => {
  debugData([
    {
      action: 'sl:modal:opened',
      data: {
        title: 'Title of the modal',
        useCallback: true,
        options: modalOptions,
      } as ModalPropsCustom,
    },
  ]);
};
