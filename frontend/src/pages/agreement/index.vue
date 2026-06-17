<template>
  <view class="doc-page">
    <view class="doc-card">
      <text class="doc-title">{{ doc.title }}</text>
      <text class="doc-meta">更新日期：{{ doc.updated }}　|　适用于「宝护健康瘦」小程序</text>
      <text class="doc-intro">{{ doc.intro }}</text>

      <view v-for="(sec, i) in doc.sections" :key="i" class="doc-section">
        <text class="sec-heading">{{ i + 1 }}. {{ sec.heading }}</text>
        <text v-for="(p, j) in sec.paragraphs" :key="j" class="sec-paragraph">{{ p }}</text>
      </view>

      <text class="doc-foot">本文档由「宝护健康瘦」运营方发布。如有疑问，请通过小程序内「客服」与我们联系。</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'

interface DocSection {
  heading: string
  paragraphs: string[]
}
interface DocContent {
  title: string
  updated: string
  intro: string
  sections: DocSection[]
}

const UPDATED = '2026-06-17'

const TERMS: DocContent = {
  title: '用户使用协议',
  updated: UPDATED,
  intro:
    '欢迎使用「宝护健康瘦」小程序（以下简称"本小程序"）。本协议是您与本小程序运营方之间就使用本小程序服务所订立的协议。请您在使用前仔细阅读，尤其是加粗及涉及免责的条款；当您勾选同意或开始使用本小程序，即视为您已阅读并接受本协议全部内容。',
  sections: [
    {
      heading: '服务内容',
      paragraphs: [
        '本小程序提供饮食、运动、体重记录与减脂计划管理，拍照识别食物热量，AI 皮肤检测，AI 中医体检（舌诊 / 面诊 / 体质辨识）以及健康养生调理建议等功能。',
        '部分功能依赖第三方服务实现，其形态与可用性可能随版本更新调整，以小程序实际展示为准。',
      ],
    },
    {
      heading: '账号与登录',
      paragraphs: [
        '您通过微信授权登录使用本小程序。部分功能（如皮肤检测、中医体检）需绑定手机号，并由运营方开通使用资格或次数后方可使用。',
        '您应妥善保管账号，并对账号下发生的全部行为负责。',
      ],
    },
    {
      heading: '用户行为规范',
      paragraphs: [
        '您承诺上传真实、合法、由本人或经授权的照片与信息，不得上传他人照片或任何违法、侵权、不良内容。',
        '您不得利用本小程序从事任何违法违规活动，不得以任何方式干扰、破坏本小程序的正常运行或第三方服务。',
      ],
    },
    {
      heading: '检测次数与增值服务',
      paragraphs: [
        '拍照识别、皮肤检测、中医体检等功能可能设有使用次数或白名单限制，具体以页面展示为准。',
        '相关次数为虚拟使用权益，除法律另有规定或运营方另有承诺外，不予退还或兑换现金。',
      ],
    },
    {
      heading: '健康与医疗免责（重要）',
      paragraphs: [
        '本小程序提供的食物热量识别、皮肤检测、中医体质辨识及一切分析报告、调理 / 养生 / 饮食建议，均基于算法与第三方模型自动生成，仅供日常健康管理与养生参考。',
        '上述内容不构成任何医疗诊断、治疗方案或专业医学意见，不能替代执业医师的面诊与诊疗。如您有健康问题或身体不适，请及时就医。',
        '您理解并同意：依据本小程序提供的信息所作出的任何决定与行为，由您自行承担相应后果。',
      ],
    },
    {
      heading: '第三方服务',
      paragraphs: [
        '本小程序的食物识别、舌面诊与体质报告、皮肤检测、AI 文本分析等能力由第三方提供，包括但不限于阿里云、脉景（杭州）健康管理、宜远智能、DeepSeek 及微信等。',
        '相关功能的可用性与结果准确性受第三方服务影响，本小程序对第三方服务的输出结果不作担保。',
      ],
    },
    {
      heading: '知识产权',
      paragraphs: [
        '本小程序的界面、文字、图标、算法及相关内容的知识产权归运营方或相应权利人所有，未经许可不得擅自使用。',
        '您上传的照片与数据权利归您所有；为向您提供服务之目的，您授权本小程序及相应第三方对其进行必要处理。',
      ],
    },
    {
      heading: '服务变更与中断',
      paragraphs: [
        '运营方有权根据运营需要变更、暂停或终止部分或全部服务，并尽量提前在小程序内公告。',
        '因系统维护、第三方故障、网络中断或不可抗力等导致的服务中断或数据延迟，运营方在法律允许范围内不承担由此产生的损失。',
      ],
    },
    {
      heading: '责任限制',
      paragraphs: [
        '在法律允许的最大范围内，对于因使用或无法使用本小程序、或因依据相关报告与建议采取行动而产生的任何间接、附带或后果性损失，运营方不承担责任。',
      ],
    },
    {
      heading: '协议的修改',
      paragraphs: [
        '运营方可不时修订本协议，修订内容将在小程序内公示，公示后即生效。若您在协议修订后继续使用本小程序，即视为接受修订后的协议。',
      ],
    },
    {
      heading: '法律适用与争议解决',
      paragraphs: [
        '本协议适用中华人民共和国法律。因本协议产生的争议，双方应友好协商解决；协商不成的，可提交运营方所在地有管辖权的人民法院处理。',
      ],
    },
  ],
}

const PRIVACY: DocContent = {
  title: '隐私协议',
  updated: UPDATED,
  intro:
    '「宝护健康瘦」小程序（以下简称"本小程序"）非常重视您的个人信息与隐私保护。本政策说明我们如何收集、使用、存储与共享您的信息，以及您依法享有的权利。请您在使用前仔细阅读，尤其是加粗及涉及敏感个人信息的内容。',
  sections: [
    {
      heading: '我们收集的信息',
      paragraphs: [
        '为向您提供服务，我们可能收集：(1) 微信授权信息（openid、昵称、头像）；(2) 手机号（用于开通与绑定增值功能）；(3) 您填写的个人健康资料（性别、年龄、生日、身高、体重、目标体重、居住地等）；(4) 您主动上传的食物照片、舌象与面象照片；(5) 您的饮食、运动、体重记录；(6) 为保障服务与安全所必需的设备与日志信息。',
        '其中，身体健康数据与舌象 / 面象照片属于个人敏感信息，我们将依法在您授权范围内谨慎处理。',
      ],
    },
    {
      heading: '我们如何使用信息',
      paragraphs: [
        '用于完成登录与账号管理、饮食运动体重记录与统计、食物热量识别、皮肤检测、中医体质辨识，以及生成检测报告与养生调理建议、提供客服与改进服务。',
      ],
    },
    {
      heading: '对外提供与第三方共享（重要）',
      paragraphs: [
        '为实现识别与分析功能，在您使用相应功能时，我们会将必要数据共享给第三方处理：拍照识别食物热量（阿里云）、AI 中医舌面诊与体质报告（脉景）、AI 皮肤检测（宜远智能）、报告文本智能分析（DeepSeek）、登录与基础能力（微信）。',
        '具体而言，当您使用上述功能时，您上传的食物 / 舌象 / 面象照片及必要资料将以接口调用方式传输至相应第三方，用于本次识别与分析。',
        '我们仅在为您提供对应功能所必需的范围内共享，并要求第三方依法依约保护您的信息，不得用于约定外的目的。',
      ],
    },
    {
      heading: '信息的存储',
      paragraphs: [
        '您的信息存储于中华人民共和国境内的服务器。除法律另有规定或为提供服务所必需外，我们仅在实现处理目的所必需的期限内保存您的信息。',
      ],
    },
    {
      heading: '信息安全',
      paragraphs: [
        '我们采取合理的技术与管理措施（如访问控制、传输加密、最小化授权等）保护您的信息安全。但请您理解，互联网环境并非绝对安全，我们将持续努力提升保护水平。',
      ],
    },
    {
      heading: '您的权利',
      paragraphs: [
        '您有权查询、更正您的个人资料；有权要求删除您的检测记录或注销账号；有权撤回此前作出的授权同意。',
        '您可通过「个人信息」页面或小程序内「客服」行使上述权利。撤回同意或注销账号后，我们将停止相应处理，并按规定删除或匿名化您的相关信息。',
      ],
    },
    {
      heading: '敏感信息与单独同意',
      paragraphs: [
        '鉴于舌象 / 面象照片及身体健康数据属于敏感个人信息，当您使用皮肤检测、中医体检功能并上传照片时，即表示您单独同意我们及相应第三方为该次检测目的处理上述信息。',
      ],
    },
    {
      heading: '未成年人保护',
      paragraphs: [
        '本小程序主要面向成年人。若您是未成年人，请在监护人的指导与同意下使用本小程序。',
      ],
    },
    {
      heading: '医疗免责',
      paragraphs: [
        '本小程序的各项检测与报告仅供健康管理与养生参考，不作为医疗诊断依据，不能替代专业医师的诊疗。如有不适请及时就医。',
      ],
    },
    {
      heading: '政策的更新',
      paragraphs: [
        '我们可能适时更新本政策，更新后将在小程序内公示，公示后即生效。',
      ],
    },
  ],
}

const doc = ref<DocContent>(TERMS)

onLoad((query) => {
  const type = query?.type === 'privacy' ? 'privacy' : 'terms'
  doc.value = type === 'privacy' ? PRIVACY : TERMS
  uni.setNavigationBarTitle({ title: doc.value.title })
})
</script>

<style lang="scss" scoped>
.doc-page { min-height: 100vh; padding: 16px; background: #f7fbf7; box-sizing: border-box; }
.doc-card { padding: 22px 18px 28px; border-radius: 20px; background: #fff; border: 1px solid #edf1e7; box-sizing: border-box; }
.doc-title { display: block; font-size: 22px; font-weight: 900; color: #1f2a1f; }
.doc-meta { display: block; margin-top: 8px; font-size: 12px; color: #9aa39a; }
.doc-intro { display: block; margin-top: 16px; font-size: 14px; line-height: 1.8; color: #4c594c; }
.doc-section { margin-top: 20px; }
.sec-heading { display: block; font-size: 16px; font-weight: 800; color: #1f2a1f; }
.sec-paragraph { display: block; margin-top: 8px; font-size: 14px; line-height: 1.85; color: #4c594c; }
.doc-foot { display: block; margin-top: 26px; padding-top: 16px; border-top: 1px solid #f0f2ee; font-size: 12px; line-height: 1.7; color: #9aa39a; }
</style>
