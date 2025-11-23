

import {onDocumentCreated} from 'firebase-functions/v2/firestore';

export const onUserProfileCreated = onDocumentCreated("users/{uid}" ,async (event) => {
    const snap = event.data;
    if(!snap) return;
    const data = snap.data();
    if(!data) return;
    
    const updateData: any = {};

    const name = String(data.name || '').trim();
    if(!name) updateData.name = 'unnamed user';

    const about = String(data.about || '').trim();
    if(about.length > 200) updateData.about = about.slice(0, 200);

    if(!data.avatar) updateData.avatar = data.avatar;

    if(Object.keys(updateData).length === 0) return;

    return snap.ref.update(updateData);
});