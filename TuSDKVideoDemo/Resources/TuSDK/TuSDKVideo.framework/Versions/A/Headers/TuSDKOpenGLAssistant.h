//
//  TuSDKOpenGLAssistant_h

//  TuSDKVideo
//
//  Created by sprint on 09/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#ifndef TuSDKOpenGLAssistant_h
#define TuSDKOpenGLAssistant_h

/** 正常角度不旋转 */
static GLfloat lsqNoRotationTextureCoordinates[] = {
    0.0f, 0.0f,1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f,};
/** 旋转270度 */
static GLfloat lsqRotateLeftTextureCoordinates[] = {
    1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f, };
/** 旋转90度 */
static GLfloat lsqRotateRightTextureCoordinates[] = {
    0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f, 1.0f, 0.0f, };
/** 垂直镜像 */
static GLfloat lsqVerticalFlipTextureCoordinates[] = {
    0.0f, 1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f, };
/** 水平镜像 */
static GLfloat lsqHorizontalFlipTextureCoordinates[] = {
    1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f, };
/** 旋转90度垂直镜像 */
static GLfloat lsqRotateRightVerticalFlipTextureCoordinates[] = {
    0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f, 1.0f, };
/** 旋转90度水平镜像 */
static GLfloat lsqRotateRightHorizontalFlipTextureCoordinates[] = {
    1.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, };
/** 旋转180度 */
static GLfloat lsqRotate180TextureCoordinates[] = {
    1.0f, 1.0f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 0.0f, };

/** 材质绘制顶点 */
static GLfloat lsqImageVertices[] = {
    -1.0f, -1.0f, 1.0f, -1.0f, -1.0f, 1.0f, 1.0f, 1.0f, };


/***
 * 根据方向获取坐标信息
 * @param rotationMode 方向
 * @return 坐标信息
 */
static GLfloat* textureCoordinatesFromOrientation(UIImageOrientation rotationMode)
{
    
    switch (rotationMode) {
        case UIImageOrientationLeft:
            return lsqRotateLeftTextureCoordinates;
        case UIImageOrientationRight:
            return lsqRotateRightTextureCoordinates;
        case UIImageOrientationDownMirrored:
            return lsqVerticalFlipTextureCoordinates;
        case UIImageOrientationUpMirrored:
            return lsqHorizontalFlipTextureCoordinates;
        case UIImageOrientationRightMirrored:
            return lsqRotateRightVerticalFlipTextureCoordinates;
        case UIImageOrientationLeftMirrored:
            return lsqRotateRightHorizontalFlipTextureCoordinates;
        case UIImageOrientationDown:
            return lsqRotate180TextureCoordinates;
        case UIImageOrientationUp:
        default:
            return lsqNoRotationTextureCoordinates;
    }
}

/** 计算旋转坐标*/
static void rotateCoordinates(UIImageOrientation rotation, GLfloat* textureCoordinates)
{
    GLfloat t[] = {textureCoordinates[0], textureCoordinates[1], textureCoordinates[2], textureCoordinates[3], textureCoordinates[4],textureCoordinates[5], textureCoordinates[6], textureCoordinates[7]};
    
    switch (rotation)
    {
        case UIImageOrientationUpMirrored:
            textureCoordinates[0] = t[2];
            textureCoordinates[1] = t[3];
            textureCoordinates[2] = t[0];
            textureCoordinates[3] = t[1];
            textureCoordinates[4] = t[6];
            textureCoordinates[5] = t[7];
            textureCoordinates[6] = t[4];
            textureCoordinates[7] = t[5];
            break;
        case UIImageOrientationDownMirrored:
            
            textureCoordinates[0] = t[4];
            textureCoordinates[1] = t[5];
            textureCoordinates[2] = t[6];
            textureCoordinates[3] = t[7];
            textureCoordinates[4] = t[0];
            textureCoordinates[5] = t[1];
            textureCoordinates[6] = t[2];
            textureCoordinates[7] = t[3];
            
            break;
        case UIImageOrientationLeft:
            
            textureCoordinates[0] = t[2];
            textureCoordinates[1] = t[3];
            textureCoordinates[2] = t[6];
            textureCoordinates[3] = t[7];
            textureCoordinates[4] = t[0];
            textureCoordinates[5] = t[1];
            textureCoordinates[6] = t[4];
            textureCoordinates[7] = t[5];
            
            
            break;
        case UIImageOrientationRight:
            
            textureCoordinates[0] = t[4];
            textureCoordinates[1] = t[5];
            textureCoordinates[2] = t[0];
            textureCoordinates[3] = t[1];
            textureCoordinates[4] = t[6];
            textureCoordinates[5] = t[7];
            textureCoordinates[6] = t[2];
            textureCoordinates[7] = t[3];
            
            
            break;
        case UIImageOrientationRightMirrored:
            
            textureCoordinates[0] = t[0];
            textureCoordinates[1] = t[1];
            textureCoordinates[2] = t[4];
            textureCoordinates[3] = t[5];
            textureCoordinates[4] = t[2];
            textureCoordinates[5] = t[3];
            textureCoordinates[6] = t[6];
            textureCoordinates[7] = t[7];
            
            break;
        case UIImageOrientationLeftMirrored:
            
            textureCoordinates[0] = t[6];
            textureCoordinates[1] = t[7];
            textureCoordinates[2] = t[2];
            textureCoordinates[3] = t[3];
            textureCoordinates[4] = t[4];
            textureCoordinates[5] = t[5];
            textureCoordinates[6] = t[0];
            textureCoordinates[7] = t[1];
            
            
            break;
        case UIImageOrientationDown:
            
            textureCoordinates[0] = t[6];
            textureCoordinates[1] = t[7];
            textureCoordinates[2] = t[4];
            textureCoordinates[3] = t[5];
            textureCoordinates[4] = t[2];
            textureCoordinates[5] = t[3];
            textureCoordinates[6] = t[0];
            textureCoordinates[7] = t[1];
            
            break;
        case UIImageOrientationUp:
        default:
            break;
    }
    
}

#endif /* TuSDKOpenGLAssistant_h */

