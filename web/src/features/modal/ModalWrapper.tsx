import React, { useState } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { useDisclosure } from "@mantine/hooks";
import OpenModalConfirm from "./ModalConfirm";
import { createStyles } from "@mantine/core";
import type { ModalProps } from "../../typings";
import { useConfig } from "../../providers/ConfigProvider";

//import { fetchNui } from "../../utils/fetchNui";

const ModalWrapper: React.FC = () => {
    const { config } = useConfig();
    const useStyles = createStyles((theme) => ({...config.modalsStyles}));
    const { classes } = useStyles();
    const [data, setData] = useState<ModalProps>({type: ""});
    const [opened, { close, open }] = useDisclosure(false);

    useNuiEvent("supv:modal:opened", (data) => {
        if (data.type === "confirm" && !data.description && !data.title && !data.subtitle) return;

        setData(data);
        open();
    });

    return (
        <>
            {opened && (
                data.type === "confirm" ? 
                    <OpenModalConfirm title={data.title} subtitle={data.subtitle} description={data.description} handleClose={close} />
                : null
            )}
        </>
    );
}

export default ModalWrapper;