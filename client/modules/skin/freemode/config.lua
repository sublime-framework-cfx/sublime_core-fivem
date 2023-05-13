local config = {}

config.components = {
    ['face_md_weight'] = {
        name = 'face_md_weight',
        label = translate('face_md_weight'),
        value = 50,
        min = 0,
        max = 100,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['skin_md_weight'] = {
        name = 'skin_md_weight',
        label = translate('skin_md_weight'),
        value = 50,
        min = 0,
        max = 100,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['nose_1'] = {
        name = 'nose_1',
        label = translate('nose_1'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'

    }, ['nose_2'] = {
        name = 'nose_2',
        label = translate('nose_2'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['nose_3'] = {
        name = 'nose_3',
        label = translate('nose_3'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['nose_4'] = {
        name = 'nose_4',
        label = translate('nose_4'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['nose_5'] = {
        name = 'nose_5',
        label = translate('nose_5'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['nose_6'] = {
        name = 'nose_6',
        label = translate('nose_6'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['eyebrows_1'] = {
        name = 'eyebrows_1',
        label = translate('eyebrows_1'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['eyebrows_2'] = {
        name = 'eyebrows_2',
        label = translate('eyebrows_2'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['cheeks_1'] = {
        name = 'cheeks_1',
        label = translate('cheeks_1'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['cheeks_2'] = {
        name = 'cheeks_2',
        label = translate('cheeks_2'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['cheeks_3'] = {
        name = 'cheeks_3',
        label = translate('cheeks_3'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['lip_thickness'] = {
        name = 'lip_thickness',
        label = translate('lip_thickness'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['jaw_1'] = {
        name = 'jaw_1',
        label = translate('jaw_1'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.6,
        type = 'skin'
    }, ['jaw_2'] = {
        name = 'jaw_2',
        label = translate('jaw_2'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.6,
        type = 'skin'
    }, ['chin_1'] = {
        name = 'chin_1',
        label = translate('chin_1'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.6,
        type = 'skin'
    }, ['chin_2'] = {
        name = 'chin_2',
        label = translate('chin_2'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.6,
        type = 'skin'
    }, ['chin_3'] = {
        name = 'chin_3',
        label = translate('chin_3'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.6,
        type = 'skin'
    }, ['chin_4'] = {
        name = 'chin_4',
        label = translate('chin_4'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.6,
        type = 'skin'
    }, ['neck_thickness'] = {
        name = 'neck_thickness',
        label = translate('neck_thickness'),
        value = 0,
        min = -10,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 1.0,
        type = 'skin'
    }, ['hair_1'] = {
        name = 'hair_1',
        label = translate('hair_1'),
        value = 0,
        min = 0,
        max = 73,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['hair_2'] = {
        name = 'hair_2',
        label = translate('hair_2'),
        value = 0,
        min = 0,
        max = 63,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'hair_1'
    }, ['hair_color_1'] = {
        name = 'hair_color_1',
        label = translate('hair_color_1'),
        value = 0,
        min = 0,
        max = 63,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        textureof = 'hair_1'
    }, ['hair_color_2'] = {
        name = 'hair_color_2',
        label = translate('hair_color_2'),
        value = 0,
        min = 0,
        max = 63,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        textureof = 'hair_2'
    }, ['tshirt_1'] = {
        name = 'tshirt_1',
        label = translate('tshirt_1'),
        value = 0,
        min = 0,
        max = 299,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe'
    }, ['tshirt_2'] = {
        name = 'tshirt_2',
        label = translate('tshirt_2'),
        value = 0,
        min = 0,
        max = 23,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe',
        drawableof = 'tshirt_1'
    }, ['torso_1'] = {
        name = 'torso_1',
        label = translate('torso_1'),
        value = 0,
        min = 0,
        max = 299,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe'
    }, ['torso_2'] = {
        name = 'torso_2',
        label = translate('torso_2'),
        value = 0,
        min = 0,
        max = 23,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe',
        drawableof = 'torso_1'
    }, ['decals_1'] = {
        name = 'decals_1',
        label = translate('decals_1'),
        value = 0,
        min = 0,
        max = 299,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe'
    }, ['decals_2'] = {
        name = 'decals_2',
        label = translate('decals_2'),
        value = 0,
        min = 0,
        max = 23,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe',
        drawableof = 'decals_1'
    }, ['arms'] = {
        name = 'arms',
        label = translate('arms'),
        value = 0,
        min = 0,
        max = 299,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe'
    }, ['arms_2'] = {
        name = 'arms_2',
        label = translate('arms_2'),
        value = 0,
        min = 0,
        max = 23,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe',
        drawableof = 'arms'
    }, ['pants_1'] = {
        name = 'pants_1',
        label = translate('pants_1'),
        value = 0,
        min = 0,
        max = 299,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe'
    }, ['pants_2'] = {
        name = 'pants_2',
        label = translate('pants_2'),
        value = 0,
        min = 0,
        max = 23,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe',
        drawableof = 'pants_1'
    }, ['shoes_1'] = {
        name = 'shoes_1',
        label = translate('shoes_1'),
        value = 0,
        min = 0,
        max = 299,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe'
    }, ['shoes_2'] = {
        name = 'shoes_2',
        label = translate('shoes_2'),
        value = 0,
        min = 0,
        max = 23,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe',
        drawableof = 'shoes_1'
    }, ['mask_1'] = {
        name = 'mask_1',
        label = translate('mask_1'),
        value = 0,
        min = 0,
        max = 119,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe'
    }, ['mask_2'] = {
        name = 'mask_2',
        label = translate('mask_2'),
        value = 0,
        min = 0,
        max = 5,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe',
        drawableof = 'mask_1'
    }, ['bproof_1'] = {
        name = 'bproof_1',
        label = translate('bproof_1'),
        value = 0,
        min = 0,
        max = 119,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe'
    }, ['bproof_2'] = {
        name = 'bproof_2',
        label = translate('bproof_2'),
        value = 0,
        min = 0,
        max = 5,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe',
        drawableof = 'bproof_1'
    }, ['chain_1'] = {
        name = 'chain_1',
        label = translate('chain_1'),
        value = 0,
        min = 0,
        max = 29,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory'
    }, ['chain_2'] = {
        name = 'chain_2',
        label = translate('chain_2'),
        value = 0,
        min = 0,
        max = 7,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory',
        drawableof = 'chain_1'
    }, ['helmet_1'] = {
        name = 'helmet_1',
        label = translate('helmet_1'),
        value = -1,
        min = -1,
        max = 119,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe'
    }, ['helmet_2'] = {
        name = 'helmet_2',
        label = translate('helmet_2'),
        value = 0,
        min = 0,
        max = 7,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'clothe',
        drawableof = 'helmet_1'
    }, ['watches_1'] = {
        name = 'watches_1',
        label = translate('watches_1'),
        value = 0,
        min = 0,
        max = 29,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory'
    }, ['watches_2'] = {
        name = 'watches_2',
        label = translate('watches_2'),
        value = 0,
        min = 0,
        max = 7,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory',
        drawableof = 'watches_1'
    }, ['bracelets_1'] = {
        name = 'bracelets_1',
        label = translate('bracelets_1'),
        value = 0,
        min = 0,
        max = 29,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory'
    }, ['bracelets_2'] = {
        name = 'bracelets_2',
        label = translate('bracelets_2'),
        value = 0,
        min = 0,
        max = 7,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory',
        drawableof = 'bracelets_1'
    }, ['glasses_1'] = {
        name = 'glasses_1',
        label = translate('glasses_1'),
        value = 0,
        min = 0,
        max = 29,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory'
    }, ['glasses_2'] = {
        name = 'glasses_2',
        label = translate('glasses_2'),
        value = 0,
        min = 0,
        max = 7,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory',
        drawableof = 'glasses_1'
    }, ['bags_1'] = {
        name = 'bags_1',
        label = translate('bags_1'),
        value = 0,
        min = 0,
        max = 29,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory'
    }, ['bags_2'] = {
        name = 'bags_2',
        label = translate('bags_2'),
        value = 0,
        min = 0,
        max = 7,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory',
        drawableof = 'bags_1'
    }, ['eye_color'] = {
        name = 'eye_color',
        label = translate('eye_color'),
        value = 0,
        min = 0,
        max = 31,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['eye_squint'] = {
        name = 'eye_squint',
        label = translate('eye_squint'),
        value = 0,
        min = 0,
        max = 9,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['eyebrows_1'] = {
        name = 'eyebrows_1',
        label = translate('eyebrows_1'),
        value = 0,
        min = 0,
        max = 33,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['eyebrows_2'] = {
        name = 'eyebrows_2',
        label = translate('eyebrows_2'),
        value = 0,
        min = 0,
        max = 33,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'eyebrows_1'
    }, ['eyebrows_3'] = {
        name = 'eyebrows_3',
        label = translate('eyebrows_3'),
        value = 0,
        min = 0,
        max = 33,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'eyebrows_1'
    }, ['eyebrows_4'] = {
        name = 'eyebrows_4',
        label = translate('eyebrows_4'),
        value = 0,
        min = 0,
        max = 33,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'eyebrows_1'
    }, ['eyebrows_5'] = {
        name = 'eyebrows_5',
        label = translate('eyebrows_5'),
        value = 0,
        min = 0,
        max = 33,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'eyebrows_1'
    }, ['eyebrows_6'] = {
        name = 'eyebrows_6',
        label = translate('eyebrows_6'),
        value = 0,
        min = 0,
        max = 33,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'eyebrows_1'
    }, ['makeup_1'] = {
        name = 'makeup_1',
        label = translate('makeup_1'),
        value = 0,
        min = 0,
        max = 74,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['makeup_2'] = {
        name = 'makeup_2',
        label = translate('makeup_2'),
        value = 0,
        min = 0,
        max = 74,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'makeup_1'
    }, ['makeup_3'] = {
        name = 'makeup_3',
        label = translate('makeup_3'),
        value = 0,
        min = 0,
        max = 74,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'makeup_1'
    }, ['makeup_4'] = {
        name = 'makeup_4',
        label = translate('makeup_4'),
        value = 0,
        min = 0,
        max = 74,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'makeup_1'
    }, ['lipstick_1'] = {
        name = 'lipstick_1',
        label = translate('lipstick_1'),
        value = 0,
        min = 0,
        max = 9,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['lipstick_2'] = {
        name = 'lipstick_2',
        label = translate('lipstick_2'),
        value = 0,
        min = 0,
        max = 9,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'lipstick_1'
    }, ['lipstick_3'] = {
        name = 'lipstick_3',
        label = translate('lipstick_3'),
        value = 0,
        min = 0,
        max = 9,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'lipstick_1'
    }, ['lipstick_4'] = {
        name = 'lipstick_4',
        label = translate('lipstick_4'),
        value = 0,
        min = 0,
        max = 9,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'lipstick_1'
    }, ['ears_1'] = {
        name = 'ears_1',
        label = translate('ears_1'),
        value = 0,
        min = 0,
        max = 2,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory'
    }, ['ears_2'] = {
        name = 'ears_2',
        label = translate('ears_2'),
        value = 0,
        min = 0,
        max = 2,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'accessory',
        drawableof = 'ears_1'
    }, ['chest_1'] = {
        name = 'chest_1',
        label = translate('chest_1'),
        value = 0,
        min = 0,
        max = 2,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['chest_2'] = {
        name = 'chest_2',
        label = translate('chest_2'),
        value = 0,
        min = 0,
        max = 2,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'chest_1'
    }, ['chest_3'] = {
        name = 'chest_3',
        label = translate('chest_3'),
        value = 0,
        min = 0,
        max = 2,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'chest_1'
    }, ['bodyb_1'] = {
        name = 'bodyb_1',
        label = translate('bodyb_1'),
        value = 0,
        min = 0,
        max = 11,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['bodyb_2'] = {
        name = 'bodyb_2',
        label = translate('bodyb_2'),
        value = 0,
        min = 0,
        max = 11,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'bodyb_1'
    }, ['bodyb_3'] = {
        name = 'bodyb_3',
        label = translate('bodyb_3'),
        value = 0,
        min = 0,
        max = 11,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'bodyb_1'
    }, ['bodyb_4'] = {
        name = 'bodyb_4',
        label = translate('bodyb_4'),
        value = 0,
        min = 0,
        max = 11,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'bodyb_1'
    }, ['age_1'] = {
        name = 'age_1',
        label = translate('age_1'),
        value = 45,
        min = 45,
        max = 74,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['age_2'] = {
        name = 'age_2',
        label = translate('age_2'),
        value = 45,
        min = 45,
        max = 74,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'age_1'
    }, ['blemishes_1'] = {
        name = 'blemishes_1',
        label = translate('blemishes_1'),
        value = 0,
        min = 0,
        max = 23,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['blemishes_2'] = {
        name = 'blemishes_2',
        label = translate('blemishes_2'),
        value = 0,
        min = 0,
        max = 23,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'blemishes_1'
    }, ['blush_1'] = {
        name = 'blush_1',
        label = translate('blush_1'),
        value = 0,
        min = 0,
        max = 9,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['blush_2'] = {
        name = 'blush_2',
        label = translate('blush_2'),
        value = 0,
        min = 0,
        max = 9,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'blush_1'
    }, ['blush_3'] = {
        name = 'blush_3',
        label = translate('blush_3'),
        value = 0,
        min = 0,
        max = 9,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'blush_1'
    }, ['complexion_1'] = {
        name = 'complexion_1',
        label = translate('complexion_1'),
        value = 0,
        min = 0,
        max = 11,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['complexion_2'] = {
        name = 'complexion_2',
        label = translate('complexion_2'),
        value = 0,
        min = 0,
        max = 11,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'complexion_1'
    }, ['sun_1'] = {
        name = 'sun_1',
        label = translate('sun_1'),
        value = 0,
        min = 0,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['sun_2'] = {
        name = 'sun_2',
        label = translate('sun_2'),
        value = 0,
        min = 0,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'sun_1'
    }, ['moles_1'] = {
        name = 'moles_1',
        label = translate('moles_1'),
        value = 0,
        min = 0,
        max = 17,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['moles_2'] = {
        name = 'moles_2',
        label = translate('moles_2'),
        value = 0,
        min = 0,
        max = 17,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'moles_1'
    }, ['beard_1'] = {
        name = 'beard_1',
        label = translate('beard_1'),
        value = 0,
        min = 0,
        max = 28,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['beard_2'] = {
        name = 'beard_2',
        label = translate('beard_2'),
        value = 0,
        min = 0,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'beard_1'
    }, ['beard_3'] = {
        name = 'beard_3',
        label = translate('beard_3'),
        value = 0,
        min = 0,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'beard_1'
    }, ['beard_4'] = {
        name = 'beard_4',
        label = translate('beard_4'),
        value = 0,
        min = 0,
        max = 10,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin',
        drawableof = 'beard_1'   
    }, ['sex'] = {
        name = 'sex',
        label = translate('sex'),
        value = 0,
        min = 0,
        max = 1,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['dad'] = {
        name = 'dad',
        label = translate('dad'),
        value = 0,
        min = 0,
        max = 20,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }, ['mom'] = {
        name = 'mom',
        label = translate('mom'),
        value = 21,
        min = 21,
        max = 45,
        zoomOffset = 0.6,
        camOffset = 0.65,
        type = 'skin'
    }
}