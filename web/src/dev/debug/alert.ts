import { debugData } from "../../utils/debugData";

export const debugAlert = () => {
  debugData([
    {
      action: 'sl:alert:opened',
      data: {
        title: 'Alert title',
        description: 'Alert description',
        /*transition: {
          name: 'skew-up',
          duration: 200,
          timingFunction: 'ease-in-out'
        },*/
      }
    }
  ]);
}