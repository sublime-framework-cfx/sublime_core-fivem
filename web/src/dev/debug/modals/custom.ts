import { debugData } from '../../../utils/debugData';
import type { ModalProps } from '../../../typings';
const modalOptions = [
  { type: 'input', name: 'inputField', label: 'Input Field', required: true },
  {
    type: 'checkbox',
    name: 'checkboxField',
    label: 'Checkbox Field',
    checked: true,
  },
  {
    type: 'password',
    name: 'inputField',
    label: 'Input Field',
    required: true,
  },
];

export const debugModalsCustom = () => {
  debugData([
    {
      action: 'sl:modal:opened',
      data: {
        type: 'custom',
        title: 'Dialog title',
        options: modalOptions,
      } as ModalProps,
    },
  ]);
};
