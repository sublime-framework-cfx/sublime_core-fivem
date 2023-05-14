import { debugData } from '../../utils/debugData';

export const debugLogin = () => {
  debugData([
    {
      action: 'sl:login:opened',
      data: null,
    },
  ]);
};
