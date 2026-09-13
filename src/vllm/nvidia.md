# Blackwell GPUs

| Segment         | Product                            | GPU / SM            |                        VRAM | Memory bandwidth |
| --------------- | ---------------------------------- | ------------------- | --------------------------: | ---------------: |
| Workstation     | RTX PRO 2000 Blackwell             | **GB206 / SM120**   |         **16 GB GDDR7 ECC** |     **448 GB/s** |
| Workstation     | RTX PRO 4000 Blackwell             | **GB205 / SM120**   |         **24 GB GDDR7 ECC** |     **672 GB/s** |
| Workstation     | RTX PRO 4000 Blackwell SFF         | **GB205 / SM120**   |         **24 GB GDDR7 ECC** |     **672 GB/s** |
| Data center     | RTX PRO 4500 Blackwell Server      | **GB203 / SM120**   |             **32 GB GDDR7** |     **896 GB/s** |
| Workstation     | RTX PRO 4500 Blackwell             | **GB203 / SM120**   |         **32 GB GDDR7 ECC** |     **896 GB/s** |
| **Consumer**    | RTX 5090                           | **GB202 / SM120**   |             **32 GB GDDR7** |   **1,792 GB/s** |
| Workstation     | RTX PRO 5000 Blackwell             | **GB202 / SM120**   |    **48 / 72 GB GDDR7 ECC** |   **1,344 GB/s** |
| Workstation     | RTX PRO 5500 Blackwell             | **GB202 / SM120**   |             **84 GB GDDR7** |   **1,792 GB/s** |
| **Data center** | RTX PRO 6000 Blackwell Server      | **GB202 / SM120**   |         **96 GB GDDR7 ECC** |   **1,792 GB/s** |
| **Workstation** | RTX PRO 6000 Blackwell Workstation | **GB202 / SM120**   |         **96 GB GDDR7 ECC** |   **1,792 GB/s** |
| Workstation     | RTX PRO 6000 Blackwell Max-Q       | **GB202 / SM120**   |         **96 GB GDDR7 ECC** |   **1,792 GB/s** |
| Data center     | B200                               | **GB100 / SM100**   |            **180 GB HBM3e** |                  |
| **Data center** | B100                               | **GB100 / SM100**   |            **192 GB HBM3e** |                  |
| **Data center** | B300                               | **GB300 / SM103**   |            **288 GB HBM3e** |                  |
| Data center     | GB200                              | **2× B200 + Grace** | **2×180 GB = 360 GB HBM3e** |                  |
| Data center     | GB300                              | **2× B300 + Grace** |            **576 GB HBM3e** |                  |

# Architectures

| Architecture        | SM version             | Example GPUs                        |
| ------------------- | ---------------------- | ----------------------------------- |
| **Ampere**          | **SM80**               | A100, A30                           |
| **Ampere**          | **SM86**               | RTX 3090, RTX 3080, A40             |
| **Hopper**          | **SM90**               | H100, H200                          |
| **Ada Lovelace**    | **SM89**               | RTX 4090, RTX 6000 Ada, L40/L40S    |
| **Blackwell**       | **SM100**              | B100, B200, GB200                   |
| **Blackwell**       | **SM103**              | B300, GB300                         |
| **Blackwell**       | **SM120**              | RTX 5090, RTX PRO Blackwell         |
| **Blackwell Ultra** | **SM100/SM103 family** | B300/GB300 depending implementation |

# Consumer

| GPU          | Architecture      | VRAM  | Memory type | Bus     | Memory bandwidth | Relative |
| ------------ | ----------------- | ----- | ----------- | ------- | ---------------- | -------- |
| **RTX 3090** | Ampere / SM86     | 24 GB | GDDR6X      | 384-bit | **936 GB/s**     | 1.00×    |
| **RTX 4090** | Ada / SM89        | 24 GB | GDDR6X      | 384-bit | **1,008 GB/s**   | 1.08×    |
| **RTX 5090** | Blackwell / SM120 | 32 GB | GDDR7       | 512-bit | **1,792 GB/s**   | 1.91×    |
